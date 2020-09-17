# Unbound_pihole
A Docker image to deploy pihole and unbound to enable dnssec, DNS over TLS and ad filtering.

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
      TZ: 'Europe/Amsterdam'
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
      TZ: 'Europe/Amsterdam'
    # Volumes store your data between container upgrades
    volumes:
       - './unbound/:/usr/local/etc/unbound'
    dns:
      - 127.0.0.1
    restart: unless-stopped

```
