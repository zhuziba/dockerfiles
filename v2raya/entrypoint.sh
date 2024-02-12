#!/bin/bash
echo "启动v2raya"
#v2raya
if [ ! -e '/etc/v2raya/supervisord.conf' ]; then
    echo "目录不存在supervisord.conf不替换"
    /usr/bin/v2raya --log-level error --log-file /var/log/v2raya.log
    else
    echo "目录存在supervisord.conf开始替换supervisord"
    cp /etc/v2raya/supervisord.conf /etc/supervisord.conf
    supervisord -c /etc/supervisord.conf
fi
tail -f /dev/null
