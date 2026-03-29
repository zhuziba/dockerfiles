FROM alpine:3.23 AS builder
RUN set -ex \
    && apk add --no-cache curl \
    && ARCH=$(uname -m) \
    && if [ "$ARCH" = "aarch64" ]; then URL="https://static.adguard.com/adguardhome/release/AdGuardHome_linux_arm64.tar.gz"; \
    elif [ "$ARCH" = "x86_64" ]; then URL="https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz"; \
    else echo "Unsupported architecture: $ARCH" && exit 1; fi \
    && curl -L -H "Cache-Control: no-cache" -o /AdGuardHome.tar.gz "$URL" \
    && tar -zxvf /AdGuardHome.tar.gz \
    && chmod +x /AdGuardHome/AdGuardHome

FROM alpine:3.23 AS runtime
COPY --from=builder /AdGuardHome/AdGuardHome /usr/bin/AdGuardHome
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
    && apk add --no-cache ca-certificates bash tzdata \
    && chmod +x /entrypoint.sh
ENV TZ=Asia/Shanghai
VOLUME /AdGuardHome
EXPOSE 53 80 3000
ENTRYPOINT ["/entrypoint.sh"]
