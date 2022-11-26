FROM alpine
ADD entrypoint.sh /entrypoint.sh
ADD smartdns.conf /smartdns/smartdns.conf
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /smartdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /smartdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
