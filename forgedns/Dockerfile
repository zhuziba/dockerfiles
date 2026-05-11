FROM alpine:3.23 AS builder
RUN set -ex \
    && apk add --no-cache curl \
    && ARCH="$(uname -m)" \
    && case "$ARCH" in \
        aarch64) URL="https://github.com/SvenShi/oxidns/releases/latest/download/forgedns-aarch64-unknown-linux-musl.tar.gz" ;; \
        x86_64) URL="https://github.com/SvenShi/oxidns/releases/latest/download/forgedns-x86_64-unknown-linux-musl.tar.gz" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && curl -L -H "Cache-Control: no-cache" -o /forgedns.tar.gz "$URL" \
    && tar -zxvf /forgedns.tar.gz -C / \
    && chmod +x /forgedns \
    && rm /forgedns.tar.gz

FROM alpine:3.23 AS runtime
COPY --from=builder /forgedns /usr/bin/forgedns
RUN set -ex \
    && apk add --no-cache ca-certificates tzdata
ENV TZ=Asia/Shanghai
VOLUME /forgedns
EXPOSE 53 9088
ENTRYPOINT ["/usr/bin/forgedns"]
CMD ["start", "-c", "/forgedns/config.yaml"]
