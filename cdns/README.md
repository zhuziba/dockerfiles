# cdns

开启混杂模式

`` 
ip link set eth0 promisc on``

docker创建网络,注意将网段改为你自己的

``docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=eth0 macnet``

``docker run -dit --restart=always --name cdns -d -v /docker/cdns:/cdns --network macnet --ip 192.168.50.254 --privileged byxiaopeng/cdns:latest``
