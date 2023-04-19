FROM alpine as builder

RUN apk update -f && apk upgrade
RUN apk add libc-dev git go upx make byacc musl gcc libevent-dev openssl-dev expat-dev hiredis-dev libsodium-dev
RUN git clone https://github.com/IrineSistiana/mosdns.git /usr/src/mosdns && cd /usr/src/mosdns && go build -o /usr/src/mosdns/mosdns
RUN git clone https://github.com/AdguardTeam/dnsproxy.git /usr/src/dnsproxy && cd /usr/src/dnsproxy && go build -mod=vendor -o /usr/src/dnsproxy/dnsproxy
RUN git clone https://github.com/NLnetLabs/unbound.git /usr/src/unbound
RUN cd /usr/src/unbound && ./configure --with-pthreads --with-ssl --with-libevent --with-libhiredis --enable-cachedb --enable-subnet --enable-dnscrypt --with-username=unbound && make -j8 && make install


#压缩文件
RUN upx /usr/src/dnsproxy/dnsproxy
RUN upx /usr/src/mosdns/mosdns

FROM alpine as runtime
COPY --from=builder /usr/src/mosdns/mosdns /usr/bin/mosdns
COPY --from=builder /usr/src/dnsproxy/dnsproxy /usr/bin/dnsproxy
COPY --from=builder /usr/local/sbin/unbound /usr/bin/unbound
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates libevent-dev hiredis-dev libsodium-dev tzdata wget bash frp redis supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /rules \ 
        && wget -O /etc/root.hints https://www.internic.net/domain/named.cache \
        && wget -O /rules/gfw.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/gfw.txt \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/accelerated-domains.china.conf \
        && wget -O /rules/CN-ip-cidr.txt https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/CN-ip-cidr.txt \
        && mkdir -p /mosdns \
        && mkdir -p /usr/local/etc/unbound \
        && chmod +x /entrypoint.sh \
        && rm -rf /usr/bin/frps \
        && rm -rf /var/cache/apk/*
VOLUME /mosdns
EXPOSE 8080
ENTRYPOINT /entrypoint.sh