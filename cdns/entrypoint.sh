#!/bin/bash
if [ ! -e '/cdns/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /cdns/redis.conf
fi
if [ ! -e '/cdns/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    /usr/bin/cdns -c /cdns/config.yaml
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /cdns/supervisord.conf /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi
tail -f /dev/null
