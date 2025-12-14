FROM alpine:3.22 AS builder
RUN set -ex \
        && apk add git wget go nodejs npm \
        && git clone https://github.com/iAJue/MoeKoeMusic.git  /usr/local/app \
        && cd /usr/local/app && npm install && npm run build:docker \
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
        && apk --no-cache add -f ca-certificates tzdata wget bash nodejs npm nginx \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && cd /app/api/ && npm install --production \
        && chmod +x /entrypoint.sh \
        && rm -rf /var/cache/apk/*
VOLUME /app
EXPOSE 8080 6521
ENTRYPOINT /entrypoint.sh