#!/bin/bash
if [ ! -e '/cdns/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /cdns/redis.conf
fi
/usr/bin/mosproxy router -c /cdns/mosproxy.yaml
tail -f /dev/null
