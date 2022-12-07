#!/bin/bash
echo "每天2点自动下载geoip和geosite文件"
echo '0 2 * * *  wget -O /mosdns/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat'>>/var/spool/cron/crontabs/root
echo '0 2 * * *  wget -O /mosdns/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat'>>/var/spool/cron/crontabs/root
echo "启动定时任务"
crond -b -l 8
echo "启动openrc后台启动"
openrc boot
/etc/init.d/mosdns start
tail -f /dev/null
