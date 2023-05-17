FROM alpine
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f bash curl tzdata dhcp \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == armv7l ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/edge/AdGuardHome_linux_armv7.tar.gz; fi \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/edge/AdGuardHome_linux_arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://static.adguard.com/adguardhome/edge/AdGuardHome_linux_amd64.tar.gz; fi \
        && tar -zxvf AdGuardHome.tar.gz \
        && rm -rf AdGuardHome.tar.gz \
        && mv /AdGuardHome/AdGuardHome /usr/bin/AdGuardHome \
        && chmod +x /usr/bin/AdGuardHome \    
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /AdGuardHome
EXPOSE 53 80 3000
ENTRYPOINT /entrypoint.sh
