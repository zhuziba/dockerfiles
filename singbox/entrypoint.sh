#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

case $down_type in
"git")
  wget -P /singbox ${down_url}
  ;;
esac

sing-box run -c /singbox/config.json
tail -f /dev/null
