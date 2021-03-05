FROM ubuntu:latest as builder

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake git libboost-all-dev cmake gcc libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev \
        build-essential libcurl4-openssl-dev libfuzzy-dev libgeoip-dev liblua5.2-dev libpcre++-dev \
        libxml2-dev libyajl-dev ssdeep unzip uuid-dev\
    && nginxver=$(echo `apt show nginx | grep '^Version: [0-9.]*' | grep -o '\b[0-9.]*'` | cut -d' ' -f 1) \
    && mkdir -p /root/nginx \
    && curl -sL https://nginx.org/download/nginx-$nginxver.tar.gz | tar xz --strip-components=1 -C /root/nginx \
    && git clone https://github.com/google/ngx_brotli.git \
    && cd /root/nginx \
    && ./configure --with-compat --add-dynamic-module=../ngx_brotli \
    && make modules \
    && cd /root \
    && git clone -b v3/master https://github.com/SpiderLabs/ModSecurity \
    && cd /root/ModSecurity \
    && ./build.sh \
    && ./configure \
    && make \
    && make install \
    && git clone https://github.com/SpiderLabs/ModSecurity-nginx \
    && cd /root/nginx \
    && ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx \
    && make modules \
    && cd /root \
    && git clone -b latest-stable https://github.com/apache/incubator-pagespeed-ngx.git \
    && cd incubator-pagespeed-ngx \
    && BIT_SIZE_NAME=x64; curl -sL `cat PSOL_BINARY_URL` | tar xz \
    && cd /root/nginx \
    && ./configure --with-compat --add-dynamic-module=../incubator-pagespeed-ngx \
    && make modules \
    && apt-get autoclean \
    && apt-get autoremove -y

FROM ubuntu:latest

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        nginx \
        openssl \
        libxml2 libpcre3 libpcre++ libyajl unzip zlib1g\
    && curl -fs http://nginx.org/keys/nginx_signing.key | apt-key add - \
    && codename=`lsb_release -cs` \
    && os=`lsb_release -is | tr '[:upper:]' '[:lower:]'` \
    && echo "deb http://packages.amplify.nginx.com/${os}/ ${codename} amplify-agent" > \
    /etc/apt/sources.list.d/nginx-amplify.list \
    && apt-get update \
    && apt-get install -y nginx-amplify-agent \
    && apt-get autoclean \
    && apt-get autoremove -y \
    && mdkir -p /usr/local/modsecurity/lib/ \
    && mkdir -p /usr/share/nginx/modules/

COPY --from=builder /root/nginx/objs/* /usr/share/nginx/modules/
COPY --from=builder /usr/local/modsecurity/lib/libmodsecurity.so /usr/local/modsecurity/lib/libmodsecurity.so

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html", "/usr/share/nginx/modules"]

EXPOSE 80
EXPOSE 443

WORKDIR /etc/nginx

CMD ["/usr/sbin/nginx" "-g" "daemon off;"]
