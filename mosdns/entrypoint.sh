#!/bin/bash
echo -e "======================== 1.0 是否启动diy脚本========================\n"
if [ ! -e '/mosdns/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /mosdns/diy.sh
fi
if [[ $down_type == git ]]; then
    echo "变量配置了远程配置运远程配置"
    wget ${down_url} -O /mosdns/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
if [ ! -e '/mosdns/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    /usr/bin/mosdns start -c /mosdns/config.yaml
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /mosdns/supervisord.conf /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi
