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
echo -e "======================== 0.2 判断配置文件是否存在文件 ========================\n"
if [ ! -e '/smartdns/smartdns.conf' ]; then
    wget -O /smartdns/anti-ad-smartdns.conf https://raw.kgithub.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf
    mv /tmp/smartdns.conf /smartdns/smartdns.conf
    echo "移动smartdns配置文件成功"
fi
smartdns -c /smartdns/smartdns.conf
echo "smartdns启动成功"
tail -f /dev/null
