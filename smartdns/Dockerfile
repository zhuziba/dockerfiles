FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add cargo git musl-dev gcc g++ wget \
        && git clone https://github.com/mokeyish/smartdns-rs.git /usr/src/smartdns-rs && cd /usr/src/smartdns-rs && cargo build --release \
        && if [ $(arch) == aarch64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/download/Release43/smartdns-aarch64; fi \
        && if [ $(arch) == x86_64 ]; then     wget -O /tmp/smartdns https://github.com/pymumu/smartdns/releases/download/Release43/smartdns-x86_64; fi \
        && chmod +x /tmp/smartdns \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/src/smartdns-rs/target/release/smartdns /usr/bin/smartdns
COPY --from=builder /tmp/smartdns /tmp/smartdns
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
