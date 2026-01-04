FROM alpine:edge AS builder
RUN set -ex \
        && apk add git curl wget go make \
        && git clone https://github.com/pmkol/mosdns-x.git /usr/src/mosdns-x && cd /usr/src/mosdns-x && go build -trimpath -o /usr/src/mosdns-x/mosdns -a -ldflags '-extldflags "-static"' \
        && mkdir -p /rules \
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt \
        && wget -O /rules/china-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt \
        && wget -O /rules/apple-cn.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt \
        && wget -O /rules/china_ip_list.txt https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt \
        && rm -rf /var/cache/apk/*

FROM alpine:3.22 AS runtime
COPY --from=builder /usr/src/mosdns-x/mosdns /usr/bin/mosdns
COPY --from=builder /rules/gfw.txt /rules/gfw.txt
COPY --from=builder /rules/china_ip_list.txt /rules/china_ip_list.txt
COPY --from=builder /rules/china-list.txt /rules/china-list.txt
COPY --from=builder /rules/apple-cn.txt /rules/apple-cn.txt
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata dhcp bash nginx supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /mosdnsx \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdnsx
EXPOSE 53 80
ENTRYPOINT ["/entrypoint.sh"]
