FROM alpine:edge as builder
ADD auto_ecs.go /auto_ecs/auto_ecs.go
ADD enabled_plugins.go /tmp/enabled_plugins.go
RUN apk update -f && apk upgrade
RUN apk add libc-dev git go upx make byacc musl gcc libevent-dev openssl-dev expat-dev hiredis-dev libsodium-dev libmnl-dev
RUN git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && mv /tmp/enabled_plugins.go /usr/src/mosdns/plugin/enabled_plugins.go && go build -p 4 -o /usr/src/mosdns/mosdns
RUN git clone https://github.com/AdguardTeam/dnsproxy.git /usr/src/dnsproxy && cd /usr/src/dnsproxy && go build -p 4 -mod=vendor -o /usr/src/dnsproxy/dnsproxy

FROM alpine as runtime
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /usr/src/dnsproxy/dnsproxy /usr/bin/dnsproxy
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \ 
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && mkdir -p /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 8080
ENTRYPOINT /entrypoint.sh