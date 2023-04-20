FROM alpine:edge as builder

RUN apk update -f && apk upgrade
RUN apk add cargo git musl-dev gcc g++

WORKDIR /usr/src

RUN git clone https://github.com/mokeyish/smartdns-rs.git /usr/src/smartdns-rs && cd /usr/src/smartdns-rs && cargo build --release
##### Runtime
FROM alpine AS runtime
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/src/smartdns-rs/target/release/smartdns /usr/bin/smartdns
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f tzdata wget bash openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /smartdns \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /smartdns
EXPOSE 53
ENTRYPOINT /entrypoint.sh