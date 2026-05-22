FROM alpine:3.23 AS builder
RUN apk add --no-cache git nodejs npm
WORKDIR /usr/src
RUN git clone https://github.com/MoeKoeMusic/MoeKoeMusic.git app
RUN git clone https://github.com/MakcRe/KuGouMusicApi api
WORKDIR /usr/src/app
RUN npm install && npm run build:docker

FROM alpine:3.23 AS runtime
ENV PORT=6521
RUN apk add --no-cache tzdata nginx ca-certificates tzdata nodejs npm
WORKDIR /app
COPY --from=builder /usr/src/api /app/api/
COPY --from=builder /usr/src/app/dist/ /app/dist/
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && cd /app/api && npm install \
 && chmod +x /entrypoint.sh \
 && rm -rf /var/cache/apk/* /tmp/*
VOLUME /app
EXPOSE 8080 6521
ENTRYPOINT ["/entrypoint.sh"]
