#!/bin/bash
set -e
echo -e "======================== 1.0 是否启动diy脚本========================\n"
if [ ! -e '/smartdns/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /smartdns/diy.sh
fi
echo "启动SmartDNS"
exec /tmp/smartdns -c /smartdns/smartdns.conf -f
