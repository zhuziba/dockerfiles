#!/bin/bash
if [ ! -e '/coredns/Corefile' ]; then
    echo "Corefile配置文件不存在请配置好在启动docker"
    touch /coredns/Corefile
fi

if [ ! -e '/coredns/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /coredns/redis.conf
fi
/usr/bin/coredns -conf /coredns/Corefile
tail -f /dev/null
