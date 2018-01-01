#!/bin/bash
mkdir -p volumes/proxy/certs
echo "Generating whoami.local"
openssl req  -newkey rsa:2048 -nodes -x509 -days 365 -keyout volumes/proxy/certs/whoami.local.key -out volumes/proxy/certs/whoami.local.crt
echo "Generating outcome-hub.local"
openssl req  -newkey rsa:2048 -nodes -x509 -days 365 -keyout volumes/proxy/certs/docker-bouncer.local.key -out volumes/proxy/certs/docker-bouncer.local.crt

