#!/bin/bash
echo -e "======================== 1.0 是否启动diy脚本========================\n"
if [ ! -e '/smartdns/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /smartdns/diy.sh
fi
echo "开始生成openrc启动配置文件"
cat <<EOF> /etc/init.d/smartdns
#!/sbin/openrc-run
name="smartdns"
command="/tmp/smartdns"
command_args="-c /smartdns/smartdns.conf -f"
command_background=true
pidfile="/run/${RC_SVCNAME}.pid"
EOF
chmod +x /etc/init.d/smartdns
#rc-update add smartdns
openrc default
rc-service smartdns start
#smartdns -c /smartdns/smartdns.conf
echo "smartdns启动成功"
tail -f /dev/null
