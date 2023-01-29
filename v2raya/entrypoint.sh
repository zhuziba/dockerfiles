#!/bin/bash

if [ ! -e '/usr/share/v2ray/v2ray' ]; then
    v2ray=v5.2.1
    echo "当前获取v2ray版本为$v2ray"
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/v2ray/v2ray.zip https://hub.nuaa.cf/v2fly/v2ray-core/releases/download/$v2ray/v2ray-linux-arm64-v8a.zip; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/v2ray/v2ray.zip https://hub.nuaa.cf/v2fly/v2ray-core/releases/download/$v2ray/v2ray-linux-64.zip; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/v2ray/v2ray.zip https://hub.nuaa.cf/v2fly/v2ray-core/releases/download/$v2ray/v2ray-linux-arm32-v7a.zip; fi
    #if [ $(arch) == aarch64 ]; then      wget -O /tmp/v2ray/v2ray.zip https://download.fastgit.org/v2fly/v2ray-core/releases/latest/download/v2ray-linux-arm64-v8a.zip; fi
    #if [ $(arch) == x86_64 ]; then     wget -O /tmp/v2ray/v2ray.zip https://download.fastgit.org/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip; fi
    #if [ $(arch) == armv7l ]; then     wget -O /tmp/v2ray/v2ray.zip https://download.fastgit.org/v2fly/v2ray-core/releases/latest/download/v2ray-linux-arm32-v7a.zip; fi
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
    chmod +x /tmp/v2ray/v2ray
    mv /tmp/v2ray/v2ray /usr/share/v2ray/v2ray
    mv /tmp/v2ray/geoip.dat /usr/local/share/v2ray/geoip.dat
    mv /tmp/v2ray/geosite.dat /usr/local/share/v2ray/geosite.dat
    rm -rf /tmp/v2ray
    echo "下载v2ray完成"
fi

if [ ! -e '/usr/local/share/v2ray/LoyalsoldierSite.dat' ]; then
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://gcore.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
    else
    echo "LoyalsoldierSite.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/v2ray/LoyalsoldierSite.dat
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://gcore.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
fi

if [ ! -e '/usr/local/share/v2ray/Loyalsoldierip.dat' ]; then
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://gcore.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
    else
    echo "Loyalsoldierip.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/v2ray/Loyalsoldierip.dat
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://gcore.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
fi

if [ ! -e '/usr/bin/v2raya' ]; then
    if [ $(arch) == aarch64 ]; then      wget https://hub.nuaa.cf/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == x86_64 ]; then     wget hhttps://hub.nuaa.cf/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == armv7l ]; then     wget hhttps://hub.nuaa.cf/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm_$VER;     chmod +x /v2raya_linux_arm_$VER;     mv /v2raya_linux_arm_$VER /usr/bin/v2raya; fi
    echo "下载v2rayA完成"
fi

if [ ! -e '/etc/v2raya/smartdns.conf' ]; then
    echo "smartdns.conf文件不存在不启动smartdns"
    else
    echo "smartdns.conf文件存在启动smartdns"
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/smartdns https://hub.nuaa.cf/pymumu/smartdns/releases/latest/download/smartdns-aarch64; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://hub.nuaa.cf/pymumu/smartdns/releases/latest/download/smartdns-x86_64; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/smartdns https://hub.nuaa.cf/pymumu/smartdns/releases/latest/download/smartdns-arm; fi
    chmod +x /tmp/smartdns
    mv /tmp/smartdns /usr/bin/smartdns
    echo "下载smartdns完成"
    smartdns -c /etc/v2raya/smartdns.conf
fi

echo "启动v2raya"
v2raya
#pm2 start v2raya --name v2raya
#v2raya --log-level error --log-file /var/log/v2raya.log
tail -f /dev/null
