#!/bin/bash

rm -rf ./tmp && mkdir ./tmp

echo "=== Generating x.509 key pair"
openssl req -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -config ./certs/openssl.cnf \
    -subj "/CN=kubernetes-vagrant-ca" \
    -keyout ./tmp/ca.key \
    -out ./tmp/ca.crt
