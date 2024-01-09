#!/bin/bash
if [ ! -e '/usr/local/share/v2ray/LoyalsoldierSite.dat' ]; then
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://raw.fgit.cf/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
    else
    echo "LoyalsoldierSite.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/v2ray/LoyalsoldierSite.dat
    echo "下载LoyalsoldierSite.dat文件"
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://raw.fgit.cf/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
fi

if [ ! -e '/usr/local/share/v2ray/Loyalsoldierip.dat' ]; then
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://raw.fgit.cf/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
    else
    echo "Loyalsoldierip.dat文件存在删除下载最新版本"
    rm -rf /usr/local/share/v2ray/Loyalsoldierip.dat
    echo "下载Loyalsoldierip.dat文件"
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://raw.fgit.cf/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
fi

echo "启动v2raya"
#v2raya
if [ ! -e '/etc/v2raya/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    /usr/bin/v2raya --log-level error --log-file /var/log/v2raya.log
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /etc/v2raya/supervisord.conf /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi
tail -f /dev/null