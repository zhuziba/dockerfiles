FROM alpine as builder

RUN apk update -f && apk upgrade
RUN apk add cargo git musl-dev gcc g++

WORKDIR /usr/src

RUN git clone https://github.com/ClassmateLin/cfdns.git /usr/src/cfdns && cd /usr/src/cfdns && cargo build --release
RUN git clone https://github.com/ClassmateLin/zzdns.git /usr/src/zzdns && cd /usr/src/zzdns && cargo build --release

# Set the working directory
WORKDIR /usr/src/cfdns
WORKDIR /usr/src/zzdns

##### Runtime
FROM alpine AS runtime

WORKDIR /usr/local/cfdns/
RUN apk update -f && apk upgrade
RUN apk add --no-cache libgcc
# Copy application binary from builder image
COPY --from=builder /usr/src/cfdns/target/release/cfdns /usr/local/cfdns/
COPY --from=builder /usr/src/zzdns/target/release/zzdns /usr/local/zzdns/

COPY conf /usr/local/cfdns/conf

# Run the application
CMD ["/usr/local/cfdns/cfdns"]