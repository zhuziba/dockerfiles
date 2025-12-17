FROM alpine:latest AS builder
RUN apk add --no-cache git nodejs npm
WORKDIR /usr/src
RUN git clone https://github.com/MoeKoeMusic/MoeKoeMusic.git app
WORKDIR /usr/src/app
RUN npm install && npm run build:docker

FROM alpine:latest AS runtime
RUN apk add --no-cache tzdata nginx ca-certificates tzdata nodejs npm
WORKDIR /app
COPY --from=builder /usr/src/app/api/ /app/api/
COPY --from=builder /usr/src/app/dist/ /app/dist/
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && cd /app/api && npm install --production \
 && chmod +x /entrypoint.sh \
 && rm -rf /var/cache/apk/* /tmp/*
VOLUME /app
EXPOSE 8080 6521
ENTRYPOINT ["/entrypoint.sh"]