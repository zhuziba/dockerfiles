#!/bin/bash
ip=`curl ipv4.ip.sb --silent`
echo "当前主机ip是$ip"
sing-box run -c /singbox/config.json
tail -f /dev/null