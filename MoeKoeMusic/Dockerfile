FROM alpine:3.22 AS builder
RUN set -ex \
        && apk add git wget go nodejs npm \
        && git clone https://github.com/iAJue/MoeKoeMusic.git  /usr/local/app \
        && cd /usr/local/app && npm install && npm run build:docker \
        && wget -P /tmp https://github.com/MetaCubeX/yacd/archive/gh-pages.zip \
        && rm -rf /var/cache/apk/*

FROM alpine:3.22
EXPOSE 8080
EXPOSE 6521
COPY --from=builder /usr/local/app/api/ /app/api/
COPY --from=builder /usr/local/app/dist/ /app/dist/
ADD /nginx.conf /etc/nginx/nginx.conf
ADD /entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget bash nginx \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && chmod +x /tmp/iptables.sh \
        && chmod +x /entrypoint.sh
VOLUME /root/.config/mihomo
EXPOSE 53 7890 7891 7892 7893 9090
ENTRYPOINT /entrypoint.sh