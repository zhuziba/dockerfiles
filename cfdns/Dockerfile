FROM alpine as builder

WORKDIR /usr/src

RUN apk add cargo git musl-dev

RUN git clone https://github.com/ClassmateLin/cfdns.git /usr/src/cfdns && cd /usr/src/cfdns && cargo build --release

# Set the working directory
WORKDIR /usr/src/cfdns


##### Runtime
FROM alpine

WORKDIR /usr/local/cfdns/

# Copy application binary from builder image
COPY --from=builder /usr/src/cfdns/target/release/cfdns /usr/local/cfdns/

COPY conf /usr/local/cfdns/conf

# Run the application
CMD ["/usr/local/cfdns/cfdns"]