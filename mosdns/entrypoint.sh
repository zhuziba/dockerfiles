#!/bin/bash
echo "开始生成nginx配置文件"
cat <<EOF> /etc/nginx/http.d/default.conf
server {
	listen 80 default_server;
	#listen [::]:80 default_server;
	charset utf-8;

     location /dns-query {
     set_real_ip_from 0.0.0.0/0;
     real_ip_header X-Forwarded-For;
     proxy_pass http://127.0.0.1:8888/dns-query;
     }
}
EOF
echo "启动nginx进程"
nginx
echo "每天2点自动下载geoip和geosite文件"
echo '0 2 * * *  wget -O /mosdns/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat'>>/var/spool/cron/crontabs/root
echo '0 2 * * *  wget -O /mosdns/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat'>>/var/spool/cron/crontabs/root
echo "启动定时任务"
crond -b -l 8
echo "启动openrc后台启动"
openrc boot
/etc/init.d/mosdns start
tail -f /dev/null
