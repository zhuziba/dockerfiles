#!/bin/bash
if [ ! -e '/coredns/Corefile' ]; then
    echo "Corefile配置文件不存在请配置好在启动docker"
    touch /coredns/Corefile
fi
/usr/bin/coredns -conf /coredns/Corefile
tail -f /dev/null