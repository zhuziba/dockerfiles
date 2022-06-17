FROM alpine:edge
ADD ./ /
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add bash curl tzdata dhcp bash s6-overlay \
        && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && if [ $(arch) == armv7l ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_armv7.tar.gz; fi \
        && if [ $(arch) == aarch64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_arm64.tar.gz; fi \
        && if [ $(arch) == x86_64 ]; then      curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_amd64.tar.gz; fi \
        && tar -zxvf AdGuardHome.tar.gz \
        && rm -r AdGuardHome.tar.gz \
        && mv /AdGuardHome/AdGuardHome /usr/bin/AdGuardHome \
        && chmod +x /usr/bin/AdGuardHome \
        && if [ -d /etc/services.d ]; then     rm -rf /etc/services.d;      ln -sf /s6-overlay/etc/services.d /etc/services.d; fi \
        && chmod +x /etc/services.d/crond/run \
        && rm -rf /var/cache/apk/* # buildkit
VOLUME /AdGuardHome
EXPOSE 53 80 3000
ENTRYPOINT ["/init"]
