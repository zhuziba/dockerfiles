#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

echo -e "======================== 0.1 判断是否安装clash文件 ========================\n"

if [ ! -e '/usr/bin/clash' ]; then
    clash=2023.04.16
    echo "当前获取clash版本为$clash"
    if [ $(arch) == aarch64 ]; then     wget -t 0 -c -P /usr/bin https://hub.gitmirror.com/https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-arm64-$clash.gz;     gunzip /usr/bin/clash-linux-arm64-$clash.gz;     mv /usr/bin/clash-linux-arm64-$clash /usr/bin/clash;     chmod +x /usr/bin/clash; fi
    if [ $(arch) == x86_64 ]; then     wget -t 0 -c -P /usr/bin https://hub.gitmirror.com/https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-$clash.gz;     gunzip /usr/bin/clash-linux-amd64-$clash.gz;     mv /usr/bin/clash-linux-amd64-$clash /usr/bin/clash;     chmod +x /usr/bin/clash; fi
    echo "下载premium clash完成"
fi

echo -e "======================== 0.2 判断目录是否存在文件 ========================\n"
if [ ! -e '/root/.config/clash/dashboard/index.html' ]; then
    echo "下载dashboard文件"
    mkdir -p /root/.config/clash/dashboard
    wget -t 0 -c https://hub.gitmirror.com/https://github.com/haishanh/yacd/releases/download/v0.3.8/yacd.tar.xz
    tar -xvf yacd.tar.xz
    mv /public/* /root/.config/clash/dashboard
    rm -rf /yacd.tar.xz
    else
    echo "dashboard文件存在删除下载最新版本"
    rm -rf /root/.config/clash/dashboard
    mkdir -p /root/.config/clash/dashboard
    wget -t 0 -c https://hub.gitmirror.com/https://github.com/haishanh/yacd/releases/download/v0.3.8/yacd.tar.xz
    tar -xvf yacd.tar.xz
    mv /public/* /root/.config/clash/dashboard
    rm -rf /yacd.tar.xz
fi

if [ ! -e '/root/.config/clash/Country.mmdb' ]; then
    echo "下载Country.mmdb文件"
    wget -t 0 -c -P /root/.config/clash https://hub.gitmirror.com/https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb
    else
    echo "Country.mmdb文件存在删除下载最新版本"
    rm -rf /root/.config/clash/Country.mmdb
    echo "下载Country.mmdb文件"
    wget -t 0 -c -P /root/.config/clash https://hub.gitmirror.com/https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb
fi

echo -e "======================== 1. 开始自定义路由表 ========================\n"
if [[ $iptables == true ]]; then
    echo "移动iptables.sh文件"
    cp /tmp/iptables.sh /root/.config/clash/iptables.sh
    bash /root/.config/clash/iptables.sh
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
if [ ! -e '/root/.config/clash/diy.sh' ]; then
    echo "目录不存在diy.sh文件不执行diy脚本"
    else
    echo "目录存在diy.sh文件执行diy脚本"
    bash /root/.config/clash/diy.sh
fi

echo -e "======================== 4. 启动clash程序 ========================\n"

if [[ $down_type == git ]]; then
    echo "变量配置了远程配置运远程配置"
    wget ${down_url} -O /root/.config/clash/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
clash
