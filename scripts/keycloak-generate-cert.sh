#!/bin/bash -e

mkdir -p /etc/keycloak/certs

pushd /etc/keycloak/certs

if [ ! -f ./keycloak.key ]; then
    echo "=== Generating CSR"
    openssl req -new \
        -newkey rsa:4096 \
        -nodes \
        -subj "/CN=192.168.205.9" \
        -addext "subjectAltName=IP:192.168.205.9" \
        -keyout keycloak.key \
        -out keycloak.csr

    echo "=== Generating x.509 key pair"
    openssl x509 -req \
        -in keycloak.csr \
        -CA /vagrant/tmp/ca.crt \
        -CAkey /vagrant/tmp/ca.key \
        -CAcreateserial \
        -extfile /vagrant/certs/keycloak.v3.ext \
        -out keycloak.crt \
        -days 365 \
        -sha256
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

echo "=== Change ownership of certs to keycloak"
sudo chown -R keycloak:keycloak /etc/keycloak/certs/*
