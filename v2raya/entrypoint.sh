if [ ! -e '/usr/bin/v2raya' ]; then
    wget -O /usr/local/share/v2ray/LoyalsoldierSite.dat https://download.fastgit.org/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
    wget -O /usr/local/share/v2ray/Loyalsoldierip.dat https://download.fastgit.org/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
    if [ $(arch) == aarch64 ]; then      wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == x86_64 ]; then     wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == armv7l ]; then     wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm_$VER;     chmod +x /v2raya_linux_arm_$VER;     mv /v2raya_linux_arm_$VER /usr/bin/v2raya; fi
    echo "下载v2rayA完成"
fi
echo "启动v2raya"
v2raya 
#v2raya --log-level error --log-file /var/log/v2raya.log
