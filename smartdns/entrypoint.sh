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
command="/usr/bin/smartdns"
command_args="run -c /smartdns/smartdns.conf -f"
command_background=true
pidfile="/run/${RC_SVCNAME}.pid"
EOF
chmod +x /etc/init.d/smartdns
#rc-update add smartdns
openrc default
rc-service smartdns start
#smartdns -c /smartdns/smartdns.conf
echo "smartdns启动成功"
echo "每周一到周五2点自动重启smartdns进程"
echo '0 2 * * 1-5  rc-service smartdns restart'>>/var/spool/cron/crontabs/root
echo "启动定时任务"
crond -b -l 8
tail -f /dev/null
