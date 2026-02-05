# MoeKoeMusic 的 Dockerfile
# 使用多阶段构建：
# - builder 阶段用于拉取源代码并构建前端与 API
# - runtime 阶段用于构建运行时镜像，仅包含运行所需的最小依赖

FROM alpine:3.22 AS builder
# 安装构建过程中需要的工具：git 用于拉取源码；nodejs 与 npm 用于安装依赖并构建
RUN apk add --no-cache git nodejs npm
WORKDIR /usr/src
# 克隆项目到容器内的 app 目录
RUN git clone https://github.com/MoeKoeMusic/MoeKoeMusic.git app
WORKDIR /usr/src/app
# 安装依赖并执行为 Docker 优化的构建任务（如有）
RUN npm install && npm run build:docker

FROM alpine:3.22 AS runtime
# 安装运行时需要的包：时区数据、nginx（用于提供静态文件）、证书、nodejs
RUN apk add --no-cache tzdata nginx ca-certificates tzdata nodejs npm
WORKDIR /app
# 将构建产物从 builder 阶段复制到运行阶段
COPY --from=builder /usr/src/app/api/ /app/api/
COPY --from=builder /usr/src/app/dist/ /app/dist/
# 使用仓库内的 nginx 配置与入口脚本
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# 设置时区为上海并安装 API 的生产依赖（忽略 dev 依赖），设置入口脚本权限，清理缓存
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && cd /app/api && npm install \
 && chmod +x /entrypoint.sh \
 && rm -rf /var/cache/apk/* /tmp/*

# 将 /app 标记为可挂载的卷（可用于持久化或调试）
VOLUME /app
# 暴露应用端口（8080）和额外端口（6521，可能用于管理/其它服务）
EXPOSE 8080 6521
# 使用 entrypoint 启动容器（通常会启动 nginx 和 node 服务）
ENTRYPOINT ["/entrypoint.sh"]
