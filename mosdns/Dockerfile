FROM alpine:edge
ADD /init/mosdns /etc/init.d/mosdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash iptables openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /mosdns \
        && chmod +x /etc/init.d/mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
