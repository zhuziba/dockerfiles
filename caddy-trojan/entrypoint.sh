#!/bin/bash
ip=`curl ipv4.ip.sb --silent`
echo "当前主机ip是$ip"
if [[ $wz == ture ]]; then
    echo "你开启了域名配置使用自己的域名"
        yuming=$domain
elif [[ $wz == false ]]; then
        yuming=$ip.nip.io
        echo "没有配置域名使用nip.io域名$yuming"
fi
echo "开始生成Caddyfile配置文件"
cat <<EOF> /etc/caddy/Caddyfile
{
    order trojan before file_server
    admin off
    servers :443 {
        listener_wrappers {
            trojan
        }
    }
    trojan {
        caddy
        no_proxy
        users $password
    }
}
:443, $yuming {
    tls $email {
        protocols tls1.2 tls1.2
        ciphers TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
    }
    trojan {
         connect_method
	    websocket
     }
    file_server {
            root /we.dog
     }
}
EOF
#openrc boot
#/etc/init.d/caddy start
caddy fmt --overwrite /etc/caddy/Caddyfile
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
echo "当前设置的trojan密码为$password"
echo "当前设置的trojan域名为$yuming"
echo "当前设置申请ssl邮箱为$email"
tail -f /dev/null
