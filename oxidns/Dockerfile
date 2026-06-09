FROM alpine:3.23 AS builder
RUN set -ex \
    && apk add --no-cache curl \
    && ARCH="$(uname -m)" \
    && case "$ARCH" in \
        aarch64) URL="https://github.com/SvenShi/oxidns/releases/latest/download/oxidns-aarch64-unknown-linux-musl.tar.gz" ;; \
        x86_64) URL="https://github.com/SvenShi/oxidns/releases/latest/download/oxidns-x86_64-unknown-linux-musl.tar.gz" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && curl -L -H "Cache-Control: no-cache" -o /oxidns.tar.gz "$URL" \
    && tar -zxvf /oxidns.tar.gz -C / \
    && chmod +x /oxidns \
    && rm /oxidns.tar.gz

FROM alpine:3.23 AS runtime
COPY --from=builder /oxidns /usr/bin/oxidns
COPY --from=builder /webui /tmp/webui
RUN set -ex \
    && apk add --no-cache ca-certificates tzdata
ENV TZ=Asia/Shanghai
VOLUME /oxidns
EXPOSE 53 9199
ENTRYPOINT ["/usr/bin/oxidns"]
CMD ["start", "-c", "/oxidns/config.yaml"]
