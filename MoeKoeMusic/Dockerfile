FROM alpine:3.24.4 AS builder
ARG MOEKOE_COMMIT=4dac953bb3b6833625908ccdc946c8898a78ddfa
ARG KUGOU_API_COMMIT=5d6c9f7b180279c9dd08bc6f7159de52a856d587
RUN apk add --no-cache git nodejs npm
WORKDIR /usr/src
RUN git clone https://github.com/MoeKoeMusic/MoeKoeMusic.git app
RUN git -C /usr/src/app checkout --detach "$MOEKOE_COMMIT"
RUN git clone https://github.com/MakcRe/KuGouMusicApi api
RUN git -C /usr/src/api checkout --detach "$KUGOU_API_COMMIT"
RUN cd /usr/src/app && npm ci && npm run build:docker
RUN npm install --global pnpm@12.23.0 \
 && cd /usr/src/api && pnpm install --frozen-lockfile

FROM alpine:3.24.4 AS runtime
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
