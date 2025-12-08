# clash

clash
开启混杂模式
``` sh
ip link set eth0 promisc on
```
docker创建网络,注意将网段改为你自己的
``` sh
docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=eth0 macnet
```
# 推荐部署容器命令
``` sh
docker run --restart=always \
  -d --name mihomo \
  --privileged=true \
  --net macnet \
  --ip 192.168.50.6 \
  -v /docker/clash:/root/.config/mihomo \
  -e iptables=true \
  -e tun=false \
  docker.1panel.live/byxiaopeng/mihomo:latest
```
想要开启tun就把tun变量改成true

重启clash容器代码
``` sh
docker restart clash
```
