FROM debian:buster

ENV VERSION 1.9.3
ENV OPENSSL_VERSION 1.1.1c
WORKDIR /usr/local/src/

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
        software-properties-common \
        build-essential \
        make \
        autoconf \
        curl \
        ca-certificates \
        dns-root-hints \
        gcc \
        bison \
        libevent-dev \
        libevent-2.1-6 \
        libexpat1-dev \
        libexpat1 \
        libtool \
        tar \
        dnsutils \
        && curl -sSL https://www.nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz | tar xz  \
        && cd ./unbound-${VERSION} \
        && $(pwd)/configure --prefix=/ \
        && make \
        && make install \
        && rm -rf ./unbound-${VERSION} \
        && apt-get purge -y \
        build-essential \
        gcc \
        bison \
        autoconf \
        make \
        build-essential \
        libexpat1-dev \
        libevent-dev \
        cpp \
        && apt-get autoremove --purge -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd --system unbound --home /home/unbound --create-home
RUN ldconfig
COPY unbound.conf /etc/unbound/unbound.conf
RUN chown -R unbound:unbound /etc/unbound/ && chown -R unbound:unbound /usr/local/etc/unbound

USER unbound
RUN unbound-anchor -a /etc/unbound/root.key ; true

EXPOSE 10053/udp
EXPOSE 10053

USER root
CMD [ "/usr/local/sbin/unbound -c /etc/unbound/unbound.conf -d -v" ]

