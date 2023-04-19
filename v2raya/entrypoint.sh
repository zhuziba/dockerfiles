#!/bin/bash
if [ ! -e '/usr/local/share/v2ray/LoyalsoldierSite.dat' ]; then
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
    else
    echo "LoyalsoldierSite.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/v2ray/LoyalsoldierSite.dat
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
fi

if [ ! -e '/usr/local/share/v2ray/Loyalsoldierip.dat' ]; then
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
    else
    echo "Loyalsoldierip.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/v2ray/Loyalsoldierip.dat
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
fi

if [ ! -e '/usr/bin/v2raya' ]; then
    if [ $(arch) == aarch64 ]; then      wget https://hub.gitmirror.com/https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == x86_64 ]; then     wget https://hub.gitmirror.com/https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == armv7l ]; then     wget https://hub.gitmirror.com/https://github.com/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm_$VER;     chmod +x /v2raya_linux_arm_$VER;     mv /v2raya_linux_arm_$VER /usr/bin/v2raya; fi
    echo "下载v2rayA完成"
fi

if [ ! -e '/etc/v2raya/smartdns.conf' ]; then
    echo "smartdns.conf文件不存在不启动smartdns"
    else
    echo "smartdns.conf文件存在启动smartdns"
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/smartdns https://hub.gitmirror.com/https://github.com/pymumu/smartdns/releases/latest/download/smartdns-aarch64; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://hub.gitmirror.com/https://github.com/pymumu/smartdns/releases/latest/download/smartdns-x86_64; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/smartdns https://hub.gitmirror.com/https://github.com/pymumu/smartdns/releases/latest/download/smartdns-arm; fi
    chmod +x /tmp/smartdns
    mv /tmp/smartdns /usr/bin/smartdns
    echo "下载smartdns完成"
    smartdns -c /etc/v2raya/smartdns.conf
fi

echo "启动v2raya"
v2raya
#v2raya --log-level error --log-file /var/log/v2raya.log