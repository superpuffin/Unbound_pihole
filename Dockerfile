FROM debian:buster

ENV VERSION 1.13.0
WORKDIR /usr/local/src/

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
        build-essential \
        make \
        autoconf \
        curl \
        ca-certificates \
        gcc \
        bison \
        libevent-dev \
        libevent-2.1-6 \
        libexpat1-dev \
        libexpat1 \
        libtool \
        tar \
        dnsutils \
        libssl-dev \
        && curl --cacert /etc/ssl/certs/ca-certificates.crt -sSL https://www.nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz | tar xz  \
        && cd ./unbound-${VERSION} \
        && ./configure \
        && make -j \
        && make install \
        && cd /usr/local/src \
        && rm -rf ./unbound-${VERSION} \
        && apt-get purge -y \
        build-essential \
        gcc \
        bison \
        autoconf \
        make \
        libexpat1-dev \
        libevent-dev \
        cpp \
        && apt-get autoremove --purge -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
        && useradd --system unbound --home /home/unbound --create-home \
        && ldconfig \
        && mv /usr/local/etc/unbound/unbound.conf /usr/local/etc/unbound/unbound.conf.orig \
        && cp /etc/ssl/certs/ca-certificates.crt /usr/local/etc/ca-certificates.crt
        
COPY unbound.conf /usr/local/etc/unbound/unbound.conf
RUN  chown -R unbound:unbound /usr/local/etc/unbound \
        && mkdir /usr/local/src/conf \
        && cp -v /usr/local/etc/unbound/* /usr/local/src/conf/
COPY --chown=root:root start.sh /start.sh
RUN chmod 754 /start.sh

EXPOSE 10053/udp
EXPOSE 10053

USER root
CMD [ "/start.sh" ]

