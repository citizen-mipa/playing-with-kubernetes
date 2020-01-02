#1a get tools etc
FROM rust:latest as cargo-build
RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl
WORKDIR /usr/src/playing-with-kubernetes

#1b avoid building dependencies
#COPY Cargo.toml Cargo.toml
#RUN mkdir src/
#RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
#RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
#RUN rm -f target/x86_64-unknown-linux-musl/release/deps/playing-with-kubernetes*

#1c building application with cargo
COPY . .
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

#2 package based on smaller image
FROM alpine:latest
COPY --from=cargo-build /usr/src/playing-with-kubernetes/target/x86_64-unknown-linux-musl/release/playing-with-kubernetes .
ENTRYPOINT ["./playing-with-kubernetes"]

