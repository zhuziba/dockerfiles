FROM alpine as builder

RUN apk update -f && apk upgrade
RUN apk add cargo git musl-dev gcc

WORKDIR /usr/src

RUN git clone https://github.com/ClassmateLin/cfdns.git /usr/src/cfdns && cd /usr/src/cfdns && cargo build --release

# Set the working directory
WORKDIR /usr/src/cfdns


##### Runtime
FROM alpine AS runtime

WORKDIR /usr/local/cfdns/

# Copy application binary from builder image
COPY --from=builder /usr/src/cfdns/target/release/cfdns /usr/local/cfdns/

COPY conf /usr/local/cfdns/conf

# Run the application
CMD ["/usr/local/cfdns/cfdns"]