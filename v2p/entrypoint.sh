#!/bin/bash
if [ ! -e '/usr/local/app/script/Shell/test.py' ]; then
    cp -r /tmp/Shell /usr/local/app/script
    echo "拷贝Shell代码"
fi

if [ ! -e '/usr/local/app/script/JSFile/0body.js' ]; then
    cp -r /tmp/JSFile /usr/local/app/script
    echo "拷贝JSFile代码"
fi

if [ ! -e '/usr/local/app/script/Lists/task.list' ]; then
    cp -r /tmp/Lists /usr/local/app/script
    echo "拷贝Lists代码"
fi

cd /usr/local/app && pm2 start index.js --name elecV2P
tail -f /dev/null
