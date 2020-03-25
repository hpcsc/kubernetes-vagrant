#!/bin/bash -e

CLIENT_NAME=$1

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
    "directAccessGrantsEnabled": true,
    "publicClient": true,
        "protocolMappers": [
        {
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
        }
    ]
}
EOF
else
    echo "=== Client ${CLIENT_NAME} exists"
fi
