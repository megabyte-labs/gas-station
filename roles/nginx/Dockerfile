FROM ubuntu:latest as builder
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        gcc \
        libpcre3 \
        libssl-dev \
        nginx \
        zlib1g \
        zlib1g-dev

FROM ubuntu:latest

WORKDIR /opt/electroneum

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        logrotate \
        nginx \
        openssl

COPY --from=builder /root/electroneum/build/release/bin/* /opt/electroneum/

EXPOSE 80 443
