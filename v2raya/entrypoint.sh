#!/bin/bash

if [ ! -e '/usr/share/xray/xray' ]; then
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/xray/Xray.zip https://download.fastgit.org/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64-v8a.zip; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/xray/Xray.zip https://download.fastgit.org/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/xray/Xray.zip https://download.fastgit.org/XTLS/Xray-core/releases/latest/download/Xray-linux-arm32-v7a.zip; fi
    unzip /tmp/xray/Xray.zip -d /tmp/xray
    chmod +x /tmp/xray/xray
    mv /tmp/xray/xray /usr/share/xray/xray
    mv /tmp/xray/geoip.dat /usr/local/share/xray/geoip.dat
    mv /tmp/xray/geosite.dat /usr/local/share/xray/geosite.dat
    rm -rf /tmp/xray
    echo "下载xray完成"
fi

if [ ! -e '/usr/local/share/xray/LoyalsoldierSite.dat' ]; then
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/xray/LoyalsoldierSite.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
    else
    echo "LoyalsoldierSite.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/xray/LoyalsoldierSite.dat
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/xray/LoyalsoldierSite.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
fi

if [ ! -e '/usr/local/share/xray/Loyalsoldierip.dat' ]; then
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/xray/Loyalsoldierip.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
    else
    echo "Loyalsoldierip.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/xray/Loyalsoldierip.dat
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/xray/Loyalsoldierip.dat https://raw.iqiq.io/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
fi

if [ ! -e '/usr/bin/v2raya' ]; then
    if [ $(arch) == aarch64 ]; then      wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == x86_64 ]; then     wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == armv7l ]; then     wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm_$VER;     chmod +x /v2raya_linux_arm_$VER;     mv /v2raya_linux_arm_$VER /usr/bin/v2raya; fi
    echo "下载v2rayA完成"
fi

if [ ! -e '/etc/v2raya/smartdns.conf' ]; then
    echo "smartdns.conf文件不存在不启动smartdns"
    else
    echo "smartdns.conf文件存在启动smartdns"
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/smartdns https://download.fastgit.org/pymumu/smartdns/releases/latest/download/smartdns-aarch64; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://download.fastgit.org/pymumu/smartdns/releases/latest/download/smartdns-x86_64; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/smartdns https://download.fastgit.org/pymumu/smartdns/releases/latest/download/smartdns-arm; fi
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
