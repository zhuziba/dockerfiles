#!/bin/bash
echo -e "======================== 0.1 判断是否安装smartdns文件 ========================\n"

if [ ! -e '/usr/bin/smartdns' ]; then
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/smartdns https://kgithub.com/pymumu/smartdns/releases/latest/download/smartdns-aarch64; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://kgithub.com/pymumu/smartdns/releases/latest/download/smartdns-x86_64; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/smartdns https://kgithub.com/pymumu/smartdns/releases/latest/download/smartdns-arm; fi
    chmod +x /tmp/smartdns
    mv /tmp/smartdns /usr/bin/smartdns
    echo "下载smartdns完成"
fi
smartdns -c /etc/smartdns/smartdns.conf
tail -f /dev/null
