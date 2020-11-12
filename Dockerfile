FROM rustlang/rust:nightly as builder
WORKDIR /usr/src

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y musl-tools && \
    rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo new gateway
WORKDIR /usr/src/gateway
COPY Cargo.toml Cargo.lock ./
COPY gateway ./gateway
COPY macros ./macros
RUN cargo install --target x86_64-unknown-linux-musl --path gateway

FROM scratch
COPY --from=builder /usr/local/cargo/bin/gateway .
USER 1000
CMD ["./gateway"]
