#!/bin/bash
if [ ! -e '/blocky/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /blocky/redis.conf
fi

cat <<EOF> /etc/supervisord.conf
[supervisord]
loglevel=info 
nodaemon=true
user=root
[program:blocky]
user=root
command=/usr/bin/blocky --config /blocky/config.yaml
EOF
if [[ $down_type == git ]]; then
    echo "变量配置了远程配置运远程配置"
    wget ${down_url} -O /blocky/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
echo "由于dns比较重要采用supervisord启动守护"
supervisord -c /etc/supervisord.conf