#!/bin/sh
if [ ! -e '/usr/bin/xray' ]; then
    if [ $(arch) == x86_64 ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.6.6-2/Xray-linux-64.zip
    fi
    if [ $(arch) == s390x ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.6.6-2/Xray-linux-s390x.zip
    fi
    if [ $(arch) == aarch64 ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.6.6-2/Xray-linux-arm64-v8a.zip
    fi
    unzip /tmp/xray/Xray.zip -d /tmp/xray
    chmod +x /tmp/xray/xray
    mv /tmp/xray/xray /usr/bin/xray
    rm -rf /tmp/xray
    echo "下载xray完成"
fi
cat << EOF > /root/config.json
{
  "log": {
    "loglevel": "none"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 8080,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "ad806487-2d26-4636-98b6-ab85cc8521f7",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/ws"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    }
  ]
}
EOF
if [ ! -e '/var/lib/nginx/html/index.html' ]; then
    git clone https://github.com/xiongbao/we.dog
    mv we.dog/* /var/lib/nginx/html/
    rm -rf /we.dog
    else
    rm -rf /var/lib/nginx/html/
    git clone https://github.com/xiongbao/we.dog 
    mv we.dog/* /var/lib/nginx/html/
    rm -rf /we.dog
fi
# start nginx
nginx
# Run xray
xray run -c /root/config.json
tail -f /dev/null
