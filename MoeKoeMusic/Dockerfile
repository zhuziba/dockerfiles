FROM alpine:3.24 AS builder
ARG MOEKOE_COMMIT=b974ff5c5183be902ff92519f4fd905ec6cae93e
ARG KUGOU_API_COMMIT=ba3645f2c89e6b9d4fec82ff783c15287e4c5f43
RUN apk add --no-cache git nodejs npm
WORKDIR /usr/src
RUN git clone https://github.com/MoeKoeMusic/MoeKoeMusic.git app
RUN git -C /usr/src/app checkout --detach "$MOEKOE_COMMIT"
RUN git clone https://github.com/MakcRe/KuGouMusicApi api
RUN git -C /usr/src/api checkout --detach "$KUGOU_API_COMMIT"
RUN cd /usr/src/app && npm ci && npm run build:docker
RUN npm install --global pnpm@12.11.2 \
 && cd /usr/src/api && pnpm install --frozen-lockfile

FROM alpine:3.24 AS runtime
ENV PORT=6521
RUN apk add --no-cache tzdata nginx ca-certificates nodejs
COPY --from=builder /usr/src/api /app/api/
COPY --from=builder /usr/src/app/dist/ /app/dist/
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && chmod +x /entrypoint.sh \
 && rm -rf /var/cache/apk/* /tmp/*
VOLUME /app
EXPOSE 8080 6521
ENTRYPOINT ["/entrypoint.sh"]
