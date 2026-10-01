# Dockerfiles

本仓库维护多个网络服务和工具的 Docker 镜像。镜像基于各自目录中的 `Dockerfile` 构建；常用配置通常通过挂载目录提供，具体文件格式请参考对应项目的 README、Dockerfile 和 `entrypoint.sh`。

## 镜像清单

下表的端口来自 Dockerfile 的 `EXPOSE` 声明，供配置端口映射时参考。DNS 服务通常需要同时开放 TCP 和 UDP；`EXPOSE` 本身不会自动发布端口。

| 目录 | Docker Hub 镜像名 | 容器端口 | 持久化/配置目录 |
| --- | --- | --- | --- |
| `oxidns` | `oxidns` | `53`、`9199` | `/oxidns` |
| `openlist` | `openlist` | `5244` | 按 OpenList 配置 |
| `AdGuardHome` | `adguardhome` | `53`、`80`、`3000` | `/AdGuardHome`、`/usr/bin/data` |
| `test` | `test` | `1080` | `/test` |
| `smartdns` | `smartdns` | `53` | `/smartdns` |
| `mihomo` | `mihomo` | `53`、`7890`–`7893`、`9090` | `/root/.config/mihomo` |
| `v2raya` | `v2raya` | `53`、`2017`、`20170`–`20172` | `/etc/v2raya` |
| `blocky` | `blocky` | `53` | `/blocky` |
| `mosproxy` | `mosproxy` | `53`、`8090` | `/mosproxy` |
| `technitium` | `technitium` | `53`、`80`、`5380` | 请按 Technitium 配置要求挂载 |
| `v2p` | `elecv2p` | `80`、`8001`、`8002` | `/usr/local/app` |
| `xray` | `xray` | `80` | 镜像内生成配置 |
| `singbox` | `singbox` | `443` | 请按 sing-box 配置要求挂载 |
| `mosdnsx` | `mosdnsx` | `53`、`80` | `/mosdnsx` |

以下项目有 Dockerfile，但当前未列入 `.github/workflows/hubdocker.yml` 的 Docker Hub 自动构建矩阵：

| 目录 | 服务 | 容器端口 |
| --- | --- | --- |
| `coredns` | CoreDNS | `53` |
| `drpyhouse` | DrpyHouse | `5678` |
| `drpys` | DrpyS | `5757` |
| `MoeKoeMusic` | MoeKoeMusic | `8080`、`6521` |
| `mosdns` | MosDNS | `53` |
| `ssws` | Shadowsocks + WebSocket | `8080` |

## 快速运行

以下示例以 Blocky 为例。将宿主机目录换成实际配置目录，并按需调整主机端口：

```sh
mkdir -p ./blocky
docker run -d \
  --name blocky \
  --restart unless-stopped \
  -p 53:53/tcp \
  -p 53:53/udp \
  -v "$(pwd)/blocky:/blocky" \
  "${DOCKER_USERNAME}/blocky:latest"
```

首次运行前，请按服务要求在挂载目录中准备配置文件。部分服务也支持 Docker `macvlan` 或主机网络等部署方式；网络模式、权限需求和暴露端口应按服务文档及实际环境设置，不要直接照搬示例中的 IP、网段或 `--privileged` 参数。

## 环境变量

只有下列变量在当前 Dockerfile 或启动脚本中有明确用途。变量名称大小写敏感。

| 变量 | 适用镜像 | 默认值/取值 | 说明 |
| --- | --- | --- | --- |
| `iptables` | `mihomo` | `true`；`true` / `false` | `true` 时运行镜像内的 iptables 路由脚本。启用前确认容器权限及宿主机网络设置。 |
| `tun` | `mihomo` | `false`；`true` / `false` | `true` 时尝试加载 TUN 内核模块；还需要宿主机内核和容器权限支持。 |
| `down_type` | `mihomo`、`blocky`、`mosdns`、`mosdnsx` | 未设置时使用挂载目录中的配置；设为 `git` 时下载远程配置 | `git` 模式需同时设置 `down_url`。下载内容会写入对应服务的 `config.yaml`。 |
| `down_url` | 同上 | 无 | 远程配置文件 URL。仅在 `down_type=git` 时使用。 |
| `TZ` | `AdGuardHome`、`oxidns` | `Asia/Shanghai`（镜像默认） | 时区设置。 |
| `PORT` | `MoeKoeMusic` | `6521`（镜像默认） | MoeKoeMusic 应用端口；镜像还声明了 Nginx 的 `8080` 端口。 |
| `MOSPROXY_JSONLOGGER` | `mosproxy` | `true`（镜像默认） | mosproxy JSON 日志选项。 |

例如，为 Mihomo 指定远程配置：

```sh
docker run -d \
  --name mihomo \
  --restart unless-stopped \
  -v ./mihomo:/root/.config/mihomo \
  -e down_type=git \
  -e down_url=https://example.com/config.yaml \
  "${DOCKER_USERNAME}/mihomo:latest"
```

启动脚本会在运行时从 `down_url` 下载配置。仅使用可信 URL；不提供上述变量时，服务使用挂载目录中的配置（如果该服务要求配置文件）。

## 配置与数据持久化

需要保留配置或数据时，将宿主机目录绑定到表格列出的容器路径。常见配置文件路径包括：

- Mihomo：`/root/.config/mihomo/config.yaml`
- Blocky：`/blocky/config.yaml`
- MosDNS：`/mosdns/config.yaml`
- MosDNS-X：`/mosdnsx/config.yaml`
- SmartDNS：`/smartdns/smartdns.conf`
- CoreDNS：`/coredns/Corefile`

具体配置格式以对应上游项目文档为准。容器升级前建议备份挂载目录。

## 构建与发布

`.github/workflows/hubdocker.yml` 在向 `main` 推送或仓库收到 watch 事件时，通过 GitHub Actions 的矩阵构建 `linux/arm64` 和 `linux/amd64` 多架构镜像并推送 Docker Hub。工作流按镜像独立缓存构建层，最多并行构建 4 个镜像。工作流需要配置仓库 Secrets：

- `DOCKER_USERNAME`：Docker Hub 用户名。
- `DOCKER_PASSWORD`：Docker Hub 密码或访问令牌。

手动本地构建单个镜像示例：

```sh
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --tag "${DOCKER_USERNAME}/blocky:latest" \
  --push \
  ./blocky
```

本地仅构建、不推送时，移除 `--push` 并按需添加 `--load`（`--load` 通常只适用于单个平台构建）。

### 依赖版本与容器进程

Dockerfile 使用版本参数固定上游应用发布版或 Git 提交，Go 构建使用 `golang:1.26-alpine3.23`，Alpine 基础镜像统一到 `3.23` 系列。更新依赖时，修改相应 Dockerfile 中的 `ARG ..._VERSION` 或 `ARG ..._COMMIT`；提交前确认上游对应版本仍提供所需架构的文件。动态更新的 Mihomo geosite 规则通过固定 SHA-256 校验，Technitium 安装包也在构建时校验 SHA-256。Alpine 软件包仓库会继续提供 `3.23` 系列更新，因此这不等同于逐字节完全可复现构建。

Node.js 项目有锁文件时使用冻结安装（`npm ci` 或 `pnpm install --frozen-lockfile`）。没有提交锁文件的上游项目仍可能在固定源码提交下解析到不同的传递依赖版本。

大多数单服务容器由 entrypoint 直接 `exec` 前台服务，以便正确传递停止信号并在服务退出时结束容器。需要多个进程的服务保留 Supervisor 或显式信号/退出状态处理，不再用 `tail -f /dev/null` 保持容器表面运行。
