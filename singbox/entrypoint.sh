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
    
#case $down_type in
#"git")
#  wget ${down_url} -O /singbox/config.json
#  ;;
#esac

sing-box run -c /singbox/config.json
tail -f /dev/null
