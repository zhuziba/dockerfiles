FROM alpine
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata wget bash openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /smartdns \
        && if [ $(arch) == aarch64 ]; then      wget -O /usr/bin/smartdns https://github.com/pymumu/smartdns/releases/latest/download/smartdns-aarch64; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /usr/bin/smartdns https://github.com/pymumu/smartdns/releases/latest/download/smartdns-x86_64; fi \
        && chmod +x /usr/bin/smartdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /smartdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh