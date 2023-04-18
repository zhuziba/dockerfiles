#!/bin/bash
if [ ! -e '/mosdns/cache.dump' ]; then
    echo "cache.dump文件不存在创建cache.dump"
    touch /mosdns/cache.dump
fi

if [ ! -e '/mosdns/redis.conf' ]; then
    echo "redis.conf文件不存在不启动redis"
    else
    echo "redis.conf文件存在启动redis"
    sysctl vm.overcommit_memory=1
    redis-server /mosdns/redis.conf
fi

echo -e "======================== 1.0 是否启动diy脚本========================\n"
if [ ! -e '/mosdns/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /mosdns/diy.sh
fi
echo "启动定时任务"
crond -b -l 8
cat <<EOF> /etc/supervisord.conf
[unix_http_server]
file=/tmp/supervisor.sock
[supervisord]
loglevel=info 
nodaemon=true
user=root
[program:mosdns]
user=root
command=/usr/bin/mosdns start -c /mosdns/config.yaml
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock
EOF
if [[ $down_type == git ]]; then
    echo "变量配置了远程配置运远程配置"
    wget ${down_url} -O /mosdns/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
if [ ! -e '/mosdns/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /mosdns/supervisord.conf /etc/supervisord.conf
fi
supervisord -c /etc/supervisord.conf
#tail -f /dev/null
