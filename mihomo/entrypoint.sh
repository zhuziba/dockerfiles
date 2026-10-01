#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

echo -e "======================== 0.1 更新Dashboard及规则文件 ========================\n"
rm -rf /root/.config/mihomo/dashboard /root/.config/mihomo/Yacd-meta-*
unzip -q /tmp/gh-pages.zip -d /root/.config/mihomo
mv /root/.config/mihomo/Yacd-meta-* /root/.config/mihomo/dashboard

cp /tmp/Country.mmdb /root/.config/mihomo/Country.mmdb
cp /tmp/geosite.dat /root/.config/mihomo/geosite.dat

echo -e "======================== 1. 开始自定义路由表 ========================\n"
if [[ $iptables == true ]]; then
    bash /tmp/iptables.sh
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

if [[ ${down_type:-} == git ]]; then
    echo "变量配置了远程配置运远程配置"
    : "${down_url:?down_url must be set when down_type=git}"
    wget "$down_url" -O /root/.config/mihomo/config.yaml
    else
    echo "变量未配置远程文件运行本地配置"
fi
exec mihomo
