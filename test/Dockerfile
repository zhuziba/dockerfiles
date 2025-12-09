FROM alpine:3.22
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash git frp supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& wget -O /tmp/china-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/refs/heads/release/china-list.txt \
        && wget -O /tmp/gfw.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/refs/heads/release/gfw.txt \
        && echo "Asia/Shanghai" > /etc/timezone \
	&& chmod +x /entrypoint.sh \
        && mkdir /test \
        && rm -rf /var/cache/apk/*
VOLUME /test
EXPOSE 1080
ENTRYPOINT ["/entrypoint.sh"]
