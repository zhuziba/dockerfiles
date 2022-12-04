#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p


if [[ $down_type == git ]]; then
    echo "变量配置了远程配置运远程配置"
    wget ${down_url} -O /singbox/config.json
    wget ${down_nginx} -O /etc/nginx/http.d/default.conf
    # start nginx
    nginx
    else
    echo "变量未配置远程文件运行本地配置"
fi
cat <<EOF> /etc/init.d/sing-box
#!/sbin/openrc-run
command="/usr/bin/sing-box"
command_args="run -c /singbox/config.json"
command_background=true
pidfile="/run/${RC_SVCNAME}.pid"
EOF
echo "启动openrc"
openrc boot
/etc/init.d/sing-box start
if [ ! -e '/singbox/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /singbox/diy.sh
fi
#sing-box run -c /singbox/config.json
tail -f /dev/null
