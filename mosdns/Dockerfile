FROM alpine as builder

WORKDIR /usr/src
RUN apk update -f && apk upgrade
RUN apk add libc-dev git go upx make byacc musl-dev gcc libevent-dev openssl-dev expat-dev hiredis-dev

RUN git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -o /usr/src/mosdns/mosdns
RUN git clone https://github.com/AdguardTeam/dnsproxy.git /usr/src/dnsproxy && cd /usr/src/dnsproxy && go build -mod=vendor -o /usr/src/dnsproxy/dnsproxy
RUN git clone https://github.com/NLnetLabs/unbound.git /usr/src/unbound && cd /usr/src/unbound && ./configure && make && make install

#压缩文件
RUN upx /usr/src/dnsproxy/dnsproxy
RUN upx /usr/src/mosdns/mosdns

WORKDIR /usr/src/mosdns
WORKDIR /usr/src/dnsproxy

FROM alpine
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /usr/src/dnsproxy/dnsproxy /usr/bin/dnsproxy
COPY --from=builder /usr/src/unbound/unbound /usr/bin/unbound
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash frp redis supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \ 
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && mkdir /mosdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
