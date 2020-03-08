#!/bin/bash -e

if [ -z "$(systemctl list-unit-files | grep keycloak)" ]; then
    KEYCLOAK_VERSION=9.0.0
    echo "=== Installing keycloak ${KEYCLOAK_VERSION}"

    cd /opt

    curl -O https://downloads.jboss.org/keycloak/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz

    tar -xvzf keycloak-${KEYCLOAK_VERSION}.tar.gz && \
        mv keycloak-${KEYCLOAK_VERSION} keycloak && \
        rm -f keycloak-${KEYCLOAK_VERSION}.tar.gz

    groupadd keycloak
    useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak
    chown -R keycloak: keycloak
    chmod o+x /opt/keycloak/bin/

    mkdir /etc/keycloak
    cp -v /opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf /etc/keycloak/keycloak.conf
    cp -v /opt/keycloak/docs/contrib/scripts/systemd/launch.sh /opt/keycloak/bin/
    chown keycloak: /opt/keycloak/bin/launch.sh
    cp -v /vagrant/keycloak.service /etc/systemd/system/keycloak.service
    /opt/keycloak/bin/add-user-keycloak.sh -u admin -p 'admin'

    systemctl daemon-reload && \
        systemctl enable keycloak && \
        systemctl start keycloak && \
        systemctl status keycloak
else
    echo "=== Keycloak is already installed"
fi;

HOST_IP=$1
echo "=== Keycloak URL: http://${HOST_IP}/auth"
echo "=== Default user:"
echo "user: admin"
echo "password: admin"
