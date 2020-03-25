#!/bin/bash

NAME_IN_CONFIG=kubernetes-vagrant-dev-1
EXISTING_USER_IN_CONFIG=$(kubectl config view -o json --raw=true | jq '.users[] | select(.name == "'${NAME_IN_CONFIG}'") | .name')

if [ -z "${EXISTING_USER_IN_CONFIG}" ]; then
     TOKEN_RESPONSE=$(curl -X POST \
                    https://192.168.205.9:8443/auth/realms/master/protocol/openid-connect/token \
                    -d grant_type=password \
                    -d username=dev-1 \
                    -d password=password.123 \
                    -d client_id=local-kubernetes \
                    -d scope=openid)

     REFRESH_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.refresh_token')

     CLUSTER_CA_DATA=$(kubectl config view -o json --raw=true \
                    | jq -r '.clusters[] | select(.cluster.server == "https://192.168.205.10:6443") | .cluster."certificate-authority-data"')

     kubectl config set-credentials ${NAME_IN_CONFIG} \
          --auth-provider=oidc \
          --auth-provider-arg=idp-issuer-url=https://192.168.205.9:8443/auth/realms/master/ \
          --auth-provider-arg=client-id=local-kubernetes \
          --auth-provider-arg=refresh-token=${REFRESH_TOKEN} \
          --auth-provider-arg=idp-certificate-authority-data=${CLUSTER_CA_DATA}
else
     echo "=== User ${EXISTING_USER_IN_CONFIG} exists in ~/.kube/config"
fi
