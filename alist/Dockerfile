FROM alpine:edge as builder
LABEL stage=go-builder
RUN apk add --no-cache bash curl gcc git go musl-dev
RUN git clone https://github.com/alist-org/alist /usr/src/alist && cd /usr/src/alist && go build -o /usr/src/alist/alist -a -ldflags '-extldflags "-static"'
RUN rm -rf /var/cache/apk/*

FROM alpine:edge
LABEL MAINTAINER="i@nn.ci"
VOLUME /opt/alist/data/
WORKDIR /opt/alist/
COPY --from=builder /usr/src/alist/alist /usr/bin/alist
COPY entrypoint.sh /entrypoint.sh
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache bash ca-certificates su-exec tzdata; \
    chmod +x /entrypoint.sh && \
    rm -rf /var/cache/apk/*
ENV PUID=0 PGID=0 UMASK=022
EXPOSE 5244
CMD [ "/entrypoint.sh" ]
