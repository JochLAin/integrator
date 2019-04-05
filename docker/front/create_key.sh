#!/bin/bash

openssl req -new -newkey rsa:4096 -days 365 -nodes \
    -x509 -subj "/C=FR/ST=Rhonealpes/L=Lyon/O=ACME/CN=magento.local" \
    -keyout ssl.key \
    -out ssl.crt
