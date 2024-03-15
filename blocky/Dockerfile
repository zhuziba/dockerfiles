FROM alpine as builder
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk add git go \
        && git clone https://github.com/0xERR0R/blocky.git /usr/src/blocky && cd /usr/src/blocky && go build -o /usr/src/blocky/blocky -a -ldflags '-extldflags "-static"'
##### Runtime
FROM alpine AS runtime
COPY --from=builder /usr/src/blocky/blocky /usr/bin/blocky
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget redis bash supervisor \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && mkdir -p /blocky \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /blocky
EXPOSE 53 4000
ENTRYPOINT /entrypoint.sh
