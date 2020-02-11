#1 Make tools source using rust image as base
FROM rust:latest as toolchain
RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl

#ENV USER=root
#ENV PATH=/root/.cargo/bin:$PATH

#2 Add new folder and add application dependencies to it
#FROM toolchain as bare-sources
#RUN cd / && \
#    mkdir -p playground && \
#    cargo init playground
WORKDIR /playground

#ADD Cargo.toml /playground/Cargo.toml
#ADD Cargo.lock /playground/Cargo.lock
#RUN cargo fetch

#3 Build dependencies to cache then and then copy the rest of the sources
#FROM bare-sources as sources
#RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
#RUN rm src/*.rs
COPY . .
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

#4 package based on smaller image
FROM alpine:latest
WORKDIR /
#COPY --from=sources /playground/target/x86_64-unknown-linux-musl/release/playing-with-kubernetes .
COPY --from=toolchain /playground/target/x86_64-unknown-linux-musl/release/playing-with-kubernetes .
EXPOSE 8080
ENTRYPOINT ["./playing-with-kubernetes"]

