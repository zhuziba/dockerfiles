#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

echo -e "======================== 0.1 判断是否安装sing-box文件 ========================\n"

if [ ! -e '/usr/bin/sing-box' ]; then
    singbox=1.1-beta12
    echo "当前获取sing-box版本为$singbox"
    if [ $(arch) == x86_64 ]; then     wget -P /tmp  https://download.nuaa.cf/SagerNet/sing-box/releases/download/$sing-box/sing-box-$singbox-linux-amd64.tar.gz;     tar -xvf /tmp/sing-box-$sing-box-linux-amd64.tar.gz;     mv /tmp/sing-box-$singbox-linux-amd64/sing-box /usr/bin/sing-box;     chmod +x /usr/bin/sing-box; fi
    if [ $(arch) == aarch64 ]; then    wget -P /tmp  https://download.nuaa.cf/SagerNet/sing-box/releases/download/$sing-box/sing-box-$singbox-linux-arm64.tar.gz;     tar -xvf /tmp/sing-box-$sing-box-linux-arm64.tar.gz;     mv /tmp/sing-box-$singbox-linux-arm64/sing-box /usr/bin/sing-box;     chmod +x /usr/bin/sing-box; fi
    echo "下载sing-box完成"

fi

sing-box run -c /singbox/config.json
tail -f /dev/null
