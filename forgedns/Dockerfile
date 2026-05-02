FROM alpine:3.23 AS builder
RUN set -ex \
    && apk add --no-cache curl \
    && ARCH=$(uname -m) \
    && if [ "$ARCH" = "aarch64" ]; then URL="https://github.com/SvenShi/forgedns/releases/latest/download/forgedns-aarch64-unknown-linux-musl.tar.gz"; \
    elif [ "$ARCH" = "x86_64" ]; then URL="https://github.com/SvenShi/forgedns/releases/latest/download/forgedns-x86_64-unknown-linux-musl.tar.gz"; \
    else echo "Unsupported architecture: $ARCH" && exit 1; fi \
    && curl -L -H "Cache-Control: no-cache" -o /forgedns.tar.gz "$URL" \
    && tar -zxvf /forgedns.tar.gz \
    && chmod +x /forgedns

FROM alpine:3.23 AS runtime
COPY --from=builder /forgedns /usr/bin/forgedns
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
    && apk add --no-cache ca-certificates bash tzdata \
    && chmod +x /entrypoint.sh
ENV TZ=Asia/Shanghai
VOLUME /forgedns
EXPOSE 53 9088
ENTRYPOINT ["/entrypoint.sh"]
