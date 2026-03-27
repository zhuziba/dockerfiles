#!/bin/bash
echo -e "======================== 0.1. 是否启动diy脚本========================\n"
if [ ! -e '/drpys/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /drpys/diy.sh
fi
cd /usr/local/app && bun start
tail -f /dev/null
