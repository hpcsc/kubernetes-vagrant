#!/bin/bash -e

GROUP_NAME=$1

if [ -z "${GROUP_NAME}" ]; then
    echo "=== group name is required"
    echo "Usage: $0 group-name"
    exit 1
fi;

source /vagrant/scripts/keycloak-login-as-admin.sh

EXISTING_GROUP=$(kcadm.sh get groups | jq -r '.[] | select(.name == "'${GROUP_NAME}'") | .name')
if [ -z "${EXISTING_GROUP}" ]; then
    echo "=== Creating group ${GROUP_NAME}"
    kcadm.sh create groups -b '{ "name": "'${GROUP_NAME}'" }'
else
    echo "=== Group ${GROUP_NAME} exists"
fi
