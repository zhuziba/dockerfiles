FROM alpine
ENV iptables=true \
    neihe=premium \
    tun=false
ADD /script/iptables.sh /tmp/iptables.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash iptables nodejs npm \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && npm install -g pm2 \
        && chmod +x /tmp/iptables.sh \
        && mkdir /sys/fs/bpf/clash \
        && rm -rf /var/cache/apk/*
VOLUME /root/.config/clash
EXPOSE 53 7890 7891 7892 7893 9090
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
