#!/bin/bash
if [ ! -e '/usr/share/v2ray/v2ray' ]; then
    if [ $(arch) == aarch64 ]; then      wget -O /tmp/v2ray/v2ray.zip https://download.fastgit.org/v2fly/v2ray-core/releases/latest/download/v2ray-linux-arm64-v8a.zip; fi
    if [ $(arch) == x86_64 ]; then     wget -O /tmp/v2ray/v2ray.zip https://download.fastgit.org/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip; fi
    if [ $(arch) == armv7l ]; then     wget -O /tmp/v2ray/v2ray.zip https://download.fastgit.org/v2fly/v2ray-core/releases/latest/download/v2ray-linux-arm32-v7a.zip; fi
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
    chmod +x /tmp/v2ray/v2ray
    mv /tmp/v2ray/v2ray /usr/share/v2ray/v2ray
    mv /tmp/v2ray/geoip.dat /usr/local/share/v2ray/geoip.dat
    mv /tmp/v2ray/geosite.dat /usr/local/share/v2ray/geosite.dat
    wget -O /tmp/v2ray/LoyalsoldierSite.dat https://raw.fastgit.org/mzz2017/dist-v2ray-rules-dat/master/geosite.dat
    mv /tmp/v2ray/LoyalsoldierSite.dat /usr/local/share/v2ray/LoyalsoldierSite.dat
    rm -rf /tmp/v2ray
    echo "下载v2ray完成"
fi

if [ ! -e '/usr/bin/v2raya' ]; then
    if [ $(arch) == aarch64 ]; then      wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm64_$VER;     chmod +x /v2raya_linux_arm64_$VER;     mv /v2raya_linux_arm64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == x86_64 ]; then     wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_x64_$VER;     chmod +x /v2raya_linux_x64_$VER;     mv /v2raya_linux_x64_$VER /usr/bin/v2raya; fi
    if [ $(arch) == armv7l ]; then     wget https://download.fastgit.org/v2rayA/v2rayA/releases/download/v$VER/v2raya_linux_arm_$VER;     chmod +x /v2raya_linux_arm_$VER;     mv /v2raya_linux_arm_$VER /usr/bin/v2raya; fi
    echo "下载v2rayA完成"
fi
v2raya
#v2raya --log-level error --log-file /var/log/v2raya.log
