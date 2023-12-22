#!/bin/bash


cat <<EOF> /etc/supervisord.conf
[unix_http_server]
file=/tmp/supervisor.sock
[supervisord]
loglevel=info 
nodaemon=true
user=root
[program:dotnet]
user=root
command=/usr/bin/dotnet /DnsServer/DnsServerApp.dll
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock
EOF

if [ ! -e '/DnsServer/config/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /DnsServer/config/supervisord.conf /etc/supervisord.conf
fi
supervisord -c /etc/supervisord.conf
