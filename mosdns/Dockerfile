FROM alpine:edge as builder
RUN apk update -f && apk upgrade
RUN apk add libc-dev git go upx make byacc musl gcc libevent-dev openssl-dev expat-dev hiredis-dev libsodium-dev libmnl-dev
RUN git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -o /usr/src/mosdns/mosdns -a -ldflags '-extldflags "-static"'

FROM alpine:edge as runtime
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash prometheus grafana frp supervisor \
        && apk --no-cache add -f vector loki loki-promtail --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \
        && mkdir -p /tmp/vector \
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && mkdir -p /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 8080
ENTRYPOINT /entrypoint.sh
