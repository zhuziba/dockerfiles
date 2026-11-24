FROM alpine:3.24.4 AS builder
ARG TECHNITIUM_VERSION=15.6.2
RUN set -ex \
        && apk add wget \
        && wget -O /tmp/DnsServerPortable.tar.gz "https://download.technitium.com/dns/archive/${TECHNITIUM_VERSION}/DnsServerPortable.tar.gz" \
        && echo "51f2d4ebaf156a85035e820afde5e1d428f1920a37d7f0c65203fb1766917e08  /tmp/DnsServerPortable.tar.gz" | sha256sum -c - \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine:3.24.4
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/DnsServerPortable.tar.gz /tmp/DnsServerPortable.tar.gz
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata dotnet8-sdk \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /DnsServer \
        && tar -xvf /tmp/DnsServerPortable.tar.gz -C /DnsServer \
        && rm -rf /tmp/DnsServerPortable.tar.gz \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /DnsServer/config
EXPOSE 53 80 5380
ENTRYPOINT ["/entrypoint.sh"]
