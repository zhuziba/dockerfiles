FROM golang:1.27-alpine3.24 AS builder
ARG COREDNS_VERSION=v1.14.7
RUN set -ex \
        && apk add --no-cache git musl-dev gcc g++ make \
        && git clone --depth 1 --branch "$COREDNS_VERSION" https://github.com/coredns/coredns.git /usr/src/coredns \
        && cd /usr/src/coredns && make \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine:3.24 AS runtime
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
ENTRYPOINT ["/entrypoint.sh"]
