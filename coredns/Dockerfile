FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add go git musl-dev gcc g++ make \
        && git clone https://github.com/coredns/coredns.git /usr/src/coredns \
        && sed -i.bak 's|forward:forward|blocklist:github.com/relekang/coredns-blocklist\ndnsredir:github.com/leiless/dnsredir\nforward:forward|g' /usr/src/coredns/plugin.cfg \
        && cd /usr/src/coredns && make \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/src/coredns/coredns /usr/bin/coredns
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata libgcc unbound-dev bash \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /coredns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /coredns
EXPOSE 53
ENTRYPOINT /entrypoint.sh
