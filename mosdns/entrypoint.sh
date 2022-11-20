#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

echo -e "======================== 0.1 判断是否安装mosdns文件 ========================\n"

if [ ! -e '/usr/bin/mosdns' ]; then
    if [ $(arch) == x86_64 ]; then    wget -P /tmp  https://kgithub.com/IrineSistiana/mosdns/releases/latest/download/mosdns-linux-amd64.zip;     unzip /tmp/mosdns-linux-amd64.zip -d /tmp;     rm -rf /tmp/mosdns-linux-arm64.zip;     mv /tmp/mosdns /usr/bin/mosdns;     chmod +x /usr/bin/mosdns; fi
    if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://kgithub.com/IrineSistiana/mosdns/releases/latest/download/mosdns-linux-arm64.zip;     unzip /tmp/mosdns-linux-arm64.zip -d /tmp;     rm -rf /tmp/mosdns-linux-arm64.zip;     mv /tmp/mosdns /usr/bin/mosdns;     chmod +x /usr/bin/mosdns; fi
    echo "下载mosdns完成"
fi
echo "每天2点自动下载geoip和geosite文件"
echo '0 2 * * *  wget -O /mosdns/geoip.dat https://kgithub.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat'>>/var/spool/cron/crontabs/root
echo '0 2 * * *  wget -O /mosdns/geosite.dat https://kgithub.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat'>>/var/spool/cron/crontabs/root
echo "启动定时任务"
crond -b -l 8
echo "启动openrc后台启动"
openrc boot
/etc/init.d/prometheus start
/etc/init.d/mosdns start
/etc/conf.d/grafana start
tail -f /dev/null
