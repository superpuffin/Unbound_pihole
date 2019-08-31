#!/bin/bash

COPY_CONFIG=${COPY_CONFIG:-no}

if [ "$COPY_CONFIG" = "yes" ]
then
    cp /usr/local/src/conf/* /usr/local/etc/unbound/ 
    chown -R unbound:unbound /usr/local/etc/unbound
fi

# Have unbound anchor refresh root keys at every restart
unbound-anchor
chown -R unbound:unbound /usr/local/etc/unbound

exec /usr/local/sbin/unbound -c /usr/local/etc/unbound/unbound.conf -d -v
