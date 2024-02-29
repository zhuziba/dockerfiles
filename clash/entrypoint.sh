#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

echo -e "======================== 0.1 判断目录是否存在文件 ========================\n"
if [ ! -e '/root/.config/mihomo/dashboard/index.html' ]; then
    echo "下载dashboard文件"
    mkdir -p /root/.config/mihomo/dashboard
    unzip /tmp/gh-pages.zip -d /root/.config/mihomo/dashboard
    else
    echo "dashboard文件存在删除下载最新版本"
    rm -rf /root/.config/mihomo/dashboard
    mkdir -p /root/.config/mihomo/dashboard
    unzip /tmp/gh-pages.zip -d /root/.config/mihomo/dashboard
fi

if [ ! -e '/root/.config/mihomo/Country.mmdb' ]; then
    echo "下载Country.mmdb文件"
    cp /tmp/Country.mmdb /root/.config/mihomo/Country.mmdb
    else
    echo "Country.mmdb文件存在删除下载最新版本"
    rm -rf /root/.config/mihomo/Country.mmdb
    echo "下载Country.mmdb文件"
    cp /tmp/Country.mmdb /root/.config/mihomo/Country.mmdb
fi

echo -e "======================== 1. 开始自定义路由表 ========================\n"
if [[ $iptables == true ]]; then
    echo "移动iptables.sh文件"
    cp /tmp/iptables.sh /root/.config/mihomo/iptables.sh
    bash /root/.config/mihomo/iptables.sh
    echo -e "自定义iptables路由表成功..."
elif [[ $iptables == false ]]; then
    echo -e "你没有设置开启iptables变量"
fi
echo -e "======================== 2. 是否内核开启tun ========================\n"
if [[ $tun == true ]]; then
    mkdir -p /lib/modules/$(uname -r)
    modprobe tun
    echo -e "如果没有报错就成功开启tun"
elif [[ $tun == false ]]; then
    echo -e "你没有设置开启tun变量"
fi
echo -e "======================== 3. 是否开启diy脚本========================\n"
if [ ! -e '/root/.config/mihomo/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /root/.config/mihomo/diy.sh
fi

echo -e "======================== 4. 启动clash程序 ========================\n"

if [[ $down_type == git ]]; then
    echo "变量配置了远程配置运远程配置"
    wget ${down_url} -O /root/.config/mihomo/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
mihomo
