FROM node:18-alpine AS builder
RUN apk add --no-cache git
WORKDIR /usr/src
RUN git clone https://github.com/MoeKoeMusic/MoeKoeMusic.git app
WORKDIR /usr/src/app
RUN npm ci && npm run build:docker

FROM node:18-alpine
# nginx + tzdata for timezone support
RUN apk add --no-cache nginx ca-certificates tzdata

WORKDIR /app
COPY --from=builder /usr/src/app/api/ /app/api/
COPY --from=builder /usr/src/app/dist/ /app/dist/
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && cd /app/api && npm ci --production --no-audit --prefer-offline \
 && chmod +x /entrypoint.sh \
 && rm -rf /var/cache/apk/* /tmp/*

VOLUME /app
EXPOSE 8080 6521
ENTRYPOINT ["/entrypoint.sh"]