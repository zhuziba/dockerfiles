#!/bin/sh
if [ ! -e '/usr/bin/xray' ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.6.4/Xray-linux-64.zip
    unzip /tmp/xray/Xray.zip -d /tmp/xray
    chmod +x /tmp/xray/xray
    mv /tmp/xray/xray /usr/bin/xray
    rm -rf /tmp/xray
    echo "下载xray完成"
fi
cat << EOF > /root/config.json
{
  "log": {
    "loglevel": "info"
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
# start nginx
nginx
# Run xray
xray -c /root/config.json
tail -f /dev/null
