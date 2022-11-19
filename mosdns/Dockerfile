FROM alpine
ADD /init/prometheus /etc/init.d/prometheus
ADD /init/mosdns /etc/init.d/mosdns
ADD /init/prometheus.yml /etc/prometheus/prometheus.yml
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash iptables openrc prometheus grafana \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir /mosdns \
        && chmod +x /etc/init.d/prometheus \
        && chmod +x /etc/init.d/mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
VOLUME /usr/share/grafana/data
EXPOSE 53 3000 9090
ENTRYPOINT /entrypoint.sh
