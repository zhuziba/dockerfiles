FROM alpine:edge as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add wget \
        && wget -P /tmp https://download.technitium.com/dns/DnsServerPortable.tar.gz  \
        && rm -rf /var/cache/apk/*
##### Runtime
FROM alpine
ADD entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/DnsServerPortable.tar.gz /tmp/DnsServerPortable.tar.gz
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates bash tzdata dotnet7-sdk \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /DnsServer \
        && tar -xvf /tmp/DnsServerPortable.tar.gz -C /DnsServer \
        && rm -rf /tmp/DnsServerPortable.tar.gz \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /DnsServer/config
ENTRYPOINT /entrypoint.sh
EXPOSE 53 80 5380
