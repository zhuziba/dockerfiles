#!/bin/bash
echo -e "======================== 0.1. 是否启动diy脚本========================\n"
if [ ! -e '/test/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /test/diy.sh
fi

if [ ! -e '/test/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /test/supervisord.conf /etc/supervisord.conf
fi
tail -f /dev/null