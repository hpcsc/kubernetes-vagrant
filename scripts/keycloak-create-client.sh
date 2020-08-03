#!/bin/bash -e

CLIENT_NAME=$1
HOST_IP=$2
PORT=8080
HOST_URL="http://${HOST_IP}:${PORT}"

if [ -z "${CLIENT_NAME}" ]; then
    echo "=== client name is required"
    echo "Usage: $0 client-name"
    exit 1
fi;

source /vagrant/scripts/keycloak-login-as-admin.sh

EXISTING_CLIENT=$(kcadm.sh get clients | jq -r '.[] | select(.clientId == "'${CLIENT_NAME}'") | .clientId')
if [ -z "${EXISTING_CLIENT}" ]; then
    echo "=== Creating client ${CLIENT_NAME}"
    kcadm.sh create clients -f - << EOF
{
    "clientId": "${CLIENT_NAME}",
    "baseUrl": "${HOST_URL}/realms/master/${CLIENT_NAME}/",
    "redirectUris": [
        "${HOST_URL}/realms/master/${CLIENT_NAME}/*"
    ],
    "clientAuthenticatorType": "client-secret",
    "enabled": true,
    "bearerOnly": false,
    "consentRequired": false,
    "standardFlowEnabled": true,
    "implicitFlowEnabled": false,
    "directAccessGrantsEnabled": true,
    "serviceAccountsEnabled": false,
    "publicClient": false,
    "frontchannelLogout": false,
    "protocol": "openid-connect",
    "protocolMappers": [{
        "name": "group-mapper",
        "protocol": "openid-connect",
        "protocolMapper": "oidc-group-membership-mapper",
        "consentRequired": false,
        "config": {
            "full.path": "true",
            "id.token.claim": "true",
            "access.token.claim": "true",
            "claim.name": "groups",
            "userinfo.token.claim": "true"
        }
    }]
}
EOF
else
    echo "=== Client ${CLIENT_NAME} exists"
fi

rm -f /vagrant/tmp/keycloak-local-kubernetes.secret

ID=$(kcadm.sh get clients | jq -r '.[] | select(.clientId == "'${CLIENT_NAME}'") | .id')
kcadm.sh get clients/${ID}/client-secret > /vagrant/tmp/keycloak-local-kubernetes.secret
