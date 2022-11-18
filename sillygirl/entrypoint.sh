#!/bin/bash


echo -e "======================== 0.1 判断是否安装傻妞文件 ========================\n"

if [ ! -e '/usr/bin/sillyGirl' ]; then
    time=curl https://cdn.staticaly.com/gh/cdle/binary/main/compile_time.go --silent | tr -cd "[0-9]""
    if [ $(arch) == x86_64 ]; then    wget -P /tmp  https://cdn.staticaly.com/gh/cdle/binary/main/sillyGirl_linux_amd64_${time};     mv /tmp/sillyGirl_linux_amd64_${time} /usr/bin/sillyGirl;     chmod +x /usr/bin/sillyGirl; fi
	if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://cdn.staticaly.com/gh/cdle/binary/main/sillyGirl_linux_arm64_${time};     mv /tmp/sillyGirl_linux_arm64_${time} /usr/bin/sillyGirl;     chmod +x /usr/bin/sillyGirl; fi
    echo "下载sillyGirl完成"
fi
sillyGirl -t
tail -f /dev/null
