#!/bin/bash
if [ ! -e '/cdns/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /cdns/redis.conf
fi
echo -e "======================== 1.0 是否启动diy脚本========================\n"
if [ ! -e '/cdns/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /cdns/diy.sh
fi
echo -e "======================== 1.1 是否启动supervisord========================\n"
if [ ! -e '/cdns/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    /usr/bin/mosproxy router -c /cdns/mosproxy.yaml
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /cdns/supervisord.conf /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi
tail -f /dev/null
