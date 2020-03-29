#!/bin/bash

COPY_CONFIG=${COPY_CONFIG:-no}
CRT_FILE=/usr/local/etc/ca-certificates.crt

if [ ! -f "/usr/local/etc/unbound/unbound.conf" ]
then
    # Commands for fist setup and copying conf files to host
    # when a volume is mounted
    unbound-control-setup
    cp /usr/local/src/conf/* /usr/local/etc/unbound/ 
    chown -R unbound:unbound /usr/local/etc/unbound
fi

# If the ca-cert file is present, make it only writable by root
    if [ -f $CRT_FILE ]
    then
    chown root:unbound $CRT_FILE
    chmod 640 $CRT_FILE
    fi

# Have unbound anchor refresh root keys at every restart
unbound-anchor
curl --cacert /etc/ssl/certs/ca-certificates.crt \
    -sSL https://www.internic.net/domain/named.root > \
    /usr/local/etc/unbound/root.hints
chown -R unbound:unbound /usr/local/etc/unbound

exec /usr/local/sbin/unbound -c /usr/local/etc/unbound/unbound.conf -d -v
