#!/bin/sh
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
cat <<EOF > /etc/supervisord.conf
[supervisord]
nodaemon=true
user=root

[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
stderr_logfile=/dev/fd/2
stderr_logfile_maxbytes=0

[program:xray]
command=/usr/bin/xray run -c /root/config.json
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
stderr_logfile=/dev/fd/2
stderr_logfile_maxbytes=0
EOF
exec supervisord -n -c /etc/supervisord.conf
