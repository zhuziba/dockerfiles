FROM alpine
ENV password=123456 \
    wz=false \
    domain=www.baidu.com \
    email=10086@baidu.com
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl git bash openrc caddy-openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == x86_64 ]; then    curl -L -H "Cache-Control: no-cache" -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com/imgk/caddy-trojan"; fi\
        && if [ $(arch) == aarch64 ]; then    curl -L -H "Cache-Control: no-cache" -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=arm64&p=github.com/imgk/caddy-trojan"; fi\
	&& if [ $(arch) == s390x ]; then    curl -L -H "Cache-Control: no-cache" -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=s390x&p=github.com/imgk/caddy-trojan"; fi\
	&& chmod +x /usr/bin/caddy \
	&& chmod +x /entrypoint.sh \
	&& mkdir -p /etc/caddy \
        && git clone https://github.com/xiongbao/we.dog \
        && rm -rf /var/cache/apk/*
EXPOSE 80 443
ENTRYPOINT /entrypoint.sh
