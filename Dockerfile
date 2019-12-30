#building application with cargo
FROM rust:latest as cargo-build
RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl
WORKDIR /usr/src/playing-with-kubernetes
COPY . .
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

#package based on smaller image
FROM alpine:latest
COPY --from=cargo-build /usr/src/playing-with-kubernetes/target/x86_64-unknown-linux-musl/release/playing-with-kubernetes .
ENTRYPOINT ["./playing-with-kubernetes"]

