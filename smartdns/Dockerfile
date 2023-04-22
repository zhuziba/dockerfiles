FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add cargo git musl-dev gcc g++ \
        #&& git clone https://github.com/mokeyish/smartdns-rs.git /usr/src/smartdns-rs && cd /usr/src/smartdns-rs && cargo build --release
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns.tar.gz https://github.com/mokeyish/smartdns-rs/releases/download/0.6.0/smartdns-x86_64-unknown-linux-musl.tar.gz;     tar -xvf /tmp/smartdns.tar.gz;     mv /smartdns-x86_64-unknown-linux-musl/smartdns /usr/bin/smartdns;     chmod +x /usr/bin/smartdns; fi \
        && if [ $(arch) == aarch64 ]; then    wget -O /tmp/smartdns.tar.gz https://github.com/mokeyish/smartdns-rs/releases/download/0.6.0/smartdns-aarch64-unknown-linux-musl.tar.gz;     tar -xvf /tmp/smartdns.tar.gz;     mv /smartdns-aarch64-unknown-linux-musl/smartdns /usr/bin/smartdns;     chmod +x /usr/bin/smartdns; fi \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/bin/smartdns /usr/bin/smartdns
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata wget libgcc bash openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /smartdns \
        && chmod +x /entrypoint.sh \
        && mkdir -p /rules \
        && wget -O /rules/accelerated-domains.china.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/smartdns/accelerated-domains.china.conf \
        && wget -O /rules/gfw.conf https://raw.githubusercontent.com/zhuziba/mosdnsrules/main/smartdns/gfw.txt \
        && rm -rf /var/cache/apk/*
VOLUME /smartdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
