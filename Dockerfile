FROM debian:buster

ENV VERSION 1.9.3
ENV OPENSSL_VERSION 1.1.1c
#WORKDIR /usr/local/src/

RUN apt-get update && apt-get install --no-install-recommends \
        software-properties-common \
        build-essential \
        make \
        autoreconf \
        curl \
        gcc \
        tar \
        dnsutils \
        && curl -sSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar xf - \
        && ./openssl-${OPENSSL_VERSION}/config \
        && make && make test \
        && make install \
        && rm -rf ./openssl-${OPENSSL_VERSION} \
        &&curl -sSL https://www.nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz | tar xf - \
        && ./unbound-${VERSION}/configure \
        && make \
        && make install \
        && rm -rf ./unbound-${VERSION} \
        && apt-get purge -y \
        build-essential \
        gcc \
        cpp \
        && apt autoremove --purge -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd --system unbound --home /home/unbound --create-home
RUN ldconfig
ADD unbound.conf /etc/unbound/unbound.conf
RUN chown -R unbound:unbound /etc/unbound/

USER unbound
RUN unbound-anchor -a /etc/unbound/root.key ; true
RUN unbound-control-setup \
	&& wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /etc/unbound/root.hints

EXPOSE 10053/udp
EXPOSE 10053

CMD [ "/sbin/unbound -c /usr/local/etc/unbound/unbound.conf -d -v" ]

