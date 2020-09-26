# Unbound_pihole
A Docker image to deploy pihole and unbound to enable dnssec, DNS over TLS and ad filtering.

The `docker-compose.yml` file below spins up a PiHole container and a Unbound container. Please note that, as no 2 services on the same machine can use the same port, the unbound container will listen on port 10053 on localhost.

The default config will forward all queries to CloudFlare DNS ([1.1.1.1](1.1.1.1)) using DNS over TLS (DoT). If you want to use antoher DNS provider (e.g. Google or Quad9) You'll need to change this in `unbound.conf`

---
Example `docker-compose` file:

```docker-compose
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    network_mode: host
    environment:
      TZ: '<YOUR TIMEZONE HERE>'
      WEBPASSWORD: '<YOUR PASSWORD HERE>'
      DNS1: 127.0.0.1#10053
      DNS2: 127.0.0.2#10000
      ServerIP: <YOUR IP HERE>
      #INTERFACE: 'eth0'
    # Volumes store your data between container upgrades
    volumes:
       - './etc-pihole/:/etc/pihole/'
       - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    dns:
      - 127.0.0.1
#      - 1.1.1.1
    # Recommended but not required (DHCP needs NET_ADMIN)
    #   https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
    cap_add:
      - NET_ADMIN
    restart: unless-stopped


  unbound:
    container_name: unbound
    image: superpuffin/unbound:latest
    network_mode: host
    environment:
      TZ: '<YOUR TIMEZONE HERE>'
    # Volumes store your data between container upgrades
    volumes:
       - './unbound/:/usr/local/etc/unbound'
    dns:
      - 127.0.0.1
    restart: unless-stopped

```
