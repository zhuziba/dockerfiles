##### Runtime
FROM alpine
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget iptables bash unzip dotnet7-sdk \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /DnsServer \
        && wget -P /tmp https://download.technitium.com/dns/DnsServerPortable.tar.gz \
        && tar -xvf /tmp/DnsServerPortable.tar.gz -C /DnsServer \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /etc/dns
ENTRYPOINT /entrypoint.sh
EXPOSE 53 80 5380
