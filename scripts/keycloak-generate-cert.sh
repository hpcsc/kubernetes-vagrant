#!/bin/bash -e

mkdir -p /etc/keycloak/certs

pushd /etc/keycloak/certs

if [ ! -f ./keycloak.key ]; then
    echo "=== Generating x.509 key pair"
    openssl req -new \
        -newkey rsa:4096 \
        -days 365 \
        -nodes \
        -x509 \
        -subj "/CN=192.168.205.9" \
        -addext "subjectAltName=IP:192.168.205.9" \
        -keyout keycloak.key \
        -out keycloak.crt
fi;

if [ ! -f ./keycloak.p12 ]; then
    echo "=== Converting keycloak x.509 cert and key to pkcs12 file"
    openssl pkcs12 -export \
        -in keycloak.crt \
        -inkey keycloak.key \
        -out keycloak.p12 \
        -name keycloak \
        -password pass:password \
        -CAfile keycloak.crt \
        -caname root
fi;

if [ ! -f ./keycloak.jks ]; then
    echo "=== Converting pkcs12 file to Java keystore"
    keytool -importkeystore \
            -deststorepass password \
            -destkeypass password \
            -destkeystore keycloak.jks \
            -srckeystore keycloak.p12 \
            -srcstoretype PKCS12 \
            -srcstorepass password \
            -alias keycloak
fi;

cp -vf ./keycloak.key /vagrant/tmp/ca.key
cp -vf ./keycloak.crt /vagrant/tmp/ca.crt

echo "=== Change ownership of certs to keycloak"
sudo chown -R keycloak:keycloak /etc/keycloak/certs/*
