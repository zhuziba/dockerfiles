FROM alpine
ENV iptables=true \
    clash=2023.04.16 \
    tun=false
ADD /script/iptables.sh /tmp/iptables.sh
ADD /entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash iptables \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && chmod +x /tmp/iptables.sh \
        && chmod +x /entrypoint.sh
VOLUME /root/.config/clash
EXPOSE 53 7890 7891 7892 7893 9090
ENTRYPOINT /entrypoint.sh
