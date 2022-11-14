FROM alpine
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash iptables openrc prometheus \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /mosdns \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ADD /init/prometheus /etc/init.d/prometheus
ADD /init/mosdns /etc/init.d/mosdns
RUN chmod +x /etc/init.d/prometheus
RUN chmod +x /etc/init.d/mosdns
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
