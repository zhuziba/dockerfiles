#!/bin/sh
if [ ! -e '/usr/bin/xray' ]; then
    if [ $(arch) == x86_64 ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
    fi
    if [ $(arch) == s390x ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-s390x.zip
    fi
    if [ $(arch) == aarch64 ]; then
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/Xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64-v8a.zip
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
VERSION=$(xray --version | grep -v unified |awk '{print $2}')
REBOOTDATE=$(date)
arch=$(arch)
sed -i "s/VERSION/$VERSION/g" /wwwroot/index.html
sed -i "s/REBOOTDATE/$REBOOTDATE/g" /wwwroot/index.html
sed -i "s/arch/$arch/g" /wwwroot/index.html
cat <<EOF> /etc/supervisord.conf
[supervisord]
loglevel=info 
nodaemon=true
user=root
[program:xray]
user=root
command=/usr/bin/xray run -c /root/config.json
EOF
/usr/sbin/nginx
/usr/bin/xray run -c /root/config.json
#supervisord -c /etc/supervisord.conf
