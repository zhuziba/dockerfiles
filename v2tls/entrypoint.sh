#!/bin/sh
if [ ! -e '/usr/bin/v2ray' ]; then
    v2ray=v5.1.0
    echo "当前获取v2ray版本为$v2ray"
    curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/$v2ray/v2ray-linux-64.zip
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
    chmod +x /tmp/v2ray/v2ray
    mv /tmp/v2ray/v2ray /usr/bin/v2ray
    rm -rf /tmp/v2ray
    echo "下载v2ray完成"
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
    },
    {
      "listen": "127.0.0.1",
      "port": 8081,
      "protocol": "shadowsocks",
      "settings": {
            "method": "chacha20-ietf-poly1305",
            "password": "peng",
            "email": "10086@gmail.com"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/peng"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF
# start nginx
nginx
# Run V2Ray
v2ray run -c /root/config.json
