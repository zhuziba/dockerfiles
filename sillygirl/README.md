# sillygirl

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
  -d --name sillygirl \
  --privileged=true \
  --net macnet \
  --ip 192.168.50.3 \
  -v /docker/sillyGirl:/etc/sillyGirl \
  byxiaopeng/sillygirl:latest
```

重启sillygirl容器代码
``` sh
docker restart sillygirl
```
