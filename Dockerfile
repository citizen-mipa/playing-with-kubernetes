#building application with cargo
FROM rust:latest as cargo-build
WORKDIR /usr/src/playing-with-kubernetes
COPY . .
RUN cargo build --release
RUN cargo install --path .

#package based on smaller image
FROM alpine:latest
COPY --from=cargo-build /usr/local/cargo/bin/playing-with-kubernetes /usr/local/bin/playing-with-kubernetes
ENTRYPOINT ["playing-with-kubernetes"]

