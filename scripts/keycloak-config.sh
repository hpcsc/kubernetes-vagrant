#!/bin/bash

HOST_IP=$1
PORT=8080
HOST_URL="http://${HOST_IP}:${PORT}"
CLIENT_NAME=local-kubernetes

TIMEOUT=15
for i in `seq $TIMEOUT` ; do
    nc -z "${HOST_IP}" "${PORT}" > /dev/null 2>&1

    if [ $? -eq 0 ] ; then
        echo "=== Keycloak is up"
        break;
    fi

    echo "=== [${i}] Keycloak is not yet up, sleeping for 1s"
    sleep 1s
done

PATH=/opt/keycloak/bin:$PATH

kcadm.sh config credentials \
    --server ${HOST_URL}/auth \
    --realm master \
    --user admin \
    --password admin

EXISTING_CLIENT=$(kcadm.sh get clients | jq -r '.[] | select(.clientId == "'${CLIENT_NAME}'") | .clientId')
echo "[$EXISTING_CLIENT]"
if [ -z "${EXISTING_CLIENT}" ]; then
    echo "=== Creating client ${CLIENT_NAME}"
    kcadm.sh create clients -f - << EOF
{
    "clientId": "${CLIENT_NAME}",
    "baseUrl": "${HOST_URL}/realms/master/${CLIENT_NAME}/",
    "redirectUris": [
        "${HOST_URL}/realms/master/${CLIENT_NAME}/*"
    ]
}
EOF
else
    echo "=== Client ${CLIENT_NAME} exists"
fi
