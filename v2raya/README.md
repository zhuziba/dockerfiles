开启混杂模式

`` 
ip link set eth0 promisc on``

docker创建网络,注意将网段改为你自己的

``docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=eth0 macnet``

``docker run -dit --restart=always --name v2raya -d -v /docker/v2raya:/etc/v2raya -v /docker/xray:/usr/local/share/xray --network macnet --ip 192.168.50.9 --privileged byxiaopeng/v2raya:latest``

v2raya面板:[http://v.mzz.pub/](http://v.mzz.pub/ "v2raya面板")
