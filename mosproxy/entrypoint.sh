#!/bin/bash
echo -e "======================== 1.0 是否启动diy脚本========================\n"
if [ ! -e '/mosproxy/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /mosproxy/diy.sh
fi
echo -e "======================== 1.1 是否启动supervisord========================\n"
if [ ! -e '/mosproxy/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    /usr/bin/mosproxy router -c /mosproxy/mosproxy.yaml
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /mosproxy/supervisord.conf /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi
tail -f /dev/null
