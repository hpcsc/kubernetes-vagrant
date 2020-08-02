#!/bin/bash -e

USERNAME=$1
PASSWORD=$2
if [ -z "${USERNAME}" ] || [ -z "${PASSWORD}" ]; then
    echo "=== username and password are required"
    echo "Usage: $0 username password"
    exit 1
fi;

TOKEN_RESPONSE=$(curl -s -X POST \
            https://192.168.205.9:8443/auth/realms/master/protocol/openid-connect/token \
            -d grant_type=password \
            -d username=${USERNAME} \
            -d password=${PASSWORD} \
            -d client_id=local-kubernetes \
            -d scope=openid)

echo $TOKEN_RESPONSE | jq -r '.refresh_token'
