#!/bin/bash
if [ ! -e '/cdns/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /cdns/redis.conf
fi

if [ ! -e '/cdns/mosproxy.yaml' ]; then
    echo "目录不存在mosproxy.yaml启动cdns"
    /usr/bin/cdns -c /cdns/config.yaml
    else
    echo "目录存在mosproxy.yaml启动mosproxy"
    /usr/bin/mosproxy router -c /cdns/mosproxy.yaml
fi
tail -f /dev/null
