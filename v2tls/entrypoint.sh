#!/bin/sh
if [ ! -e '/usr/bin/xray' ]; then
    if [ $(arch) == x86_64 ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.2/Xray-linux-64.zip
    curl -L -H "Cache-Control: no-cache" -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com/caddy-dns/cloudflare"
    chmod +x /usr/bin/caddy
    fi
    if [ $(arch) == s390x ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.2/Xray-linux-s390x.zip
    curl -L -H "Cache-Control: no-cache" -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=s390x&p=github.com/caddy-dns/cloudflare"
    chmod +x /usr/bin/caddy
    fi
    if [ $(arch) == aarch64 ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.2/Xray-linux-arm64-v8a.zip
    curl -L -H "Cache-Control: no-cache" -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=arm64&p=github.com/caddy-dns/cloudflare"
    chmod +x /usr/bin/caddy
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
		"port": 1111,
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
		"port": 1112,
		"protocol": "shadowsocks",
		"settings": {
		  "clients": [
			{
			  "method": "chacha20-ietf-poly1305",
			  "password": "ad806487-2d26-4636-98b6-ab85cc8521f7"
			}
		  ],
		  "decryption": "none"
		},
		"streamSettings": {
		  "network": "ws",
		  "wsSettings": {
			"path": "/ss"
		  }
		}
	  },
	{
		"listen": "127.0.0.1",
		"port": 1113,
		"protocol": "vless",
		"settings": {
			"clients": [
				{
					"id": "ad806487-2d26-4636-98b6-ab85cc8521f7"
				}
			],
			"decryption": "none"
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
				"path": "/vless"
			}
		}
    },
    {
        "listen": "127.0.0.1",
        "port": 1114,
        "protocol": "trojan",
        "settings": {
            "clients": [
                {
                    "password": "ad806487-2d26-4636-98b6-ab85cc8521f7"
                }
            ],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "/trojan"
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

echo "开始生成Caddyfile配置文件"

cat <<EOF> /etc/caddy/Caddyfile
:80 {
	@vws {
		path /ws
		header Connection *Upgrade*
		header Upgrade websocket
	}
	reverse_proxy @vws 127.0.0.1:1111
	@ss {
		path /ss
		header Connection *Upgrade*
		header Upgrade websocket
	}
       reverse_proxy @ss 127.0.0.1:1112
	@vless {
		path /vless
		header Connection *Upgrade*
		header Upgrade websocket
	}
       reverse_proxy @vless 127.0.0.1:1113
	@trojan {
		path /trojan
		header Connection *Upgrade*
		header Upgrade websocket
	}
       reverse_proxy @trojan 127.0.0.1:1114
       file_server {
       root /we.dog
      }
}
EOF
git clone https://github.com/xiongbao/we.dog
caddy fmt --overwrite /etc/caddy/Caddyfile
caddy start --config /etc/caddy/Caddyfile --adapter caddyfile
# Run xray
xray run -c /root/config.json
tail -f /dev/null
