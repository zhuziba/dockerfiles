#!/bin/bash
set -e

if [ ! -d '/blocky/logs' ]; then
    echo "logs目录不存在创建logs目录"
    mkdir -p /blocky/logs
fi

cat <<EOF> /etc/supervisord.conf
[unix_http_server]
file=/tmp/supervisor.sock
[supervisord]
loglevel=info 
nodaemon=true
user=root
[program:blocky]
user=root
command=/usr/bin/blocky --config /blocky/config.yaml
priority=20
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock
EOF
if [[ ${down_type:-} == git ]]; then
    echo "变量配置了远程配置运远程配置"
    : "${down_url:?down_url must be set when down_type=git}"
    wget "$down_url" -O /blocky/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
if [ -e /blocky/redis.conf ]; then
    sysctl vm.overcommit_memory=1 || echo "无法调整 vm.overcommit_memory，继续启动 Redis" >&2
    cat <<EOF >> /etc/supervisord.conf
[program:redis]
user=root
command=/usr/bin/redis-server /blocky/redis.conf --daemonize no
priority=10
EOF
fi
echo "由于dns比较重要采用supervisord启动守护"
exec supervisord -n -c /etc/supervisord.conf