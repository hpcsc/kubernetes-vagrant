#!/bin/bash -e

NAME_IN_CONFIG=kubernetes-vagrant-dev-1

REFRESH_TOKEN=$(./get-refresh-token.sh dev-1 password.123)

CLUSTER_CA_DATA=$(kubectl config view -o json --raw=true \
               | jq -r '.clusters[] | select(.cluster.server == "https://192.168.205.10:6443") | .cluster."certificate-authority-data"')

kubectl config set-credentials ${NAME_IN_CONFIG} \
     --auth-provider=oidc \
     --auth-provider-arg=idp-issuer-url=https://192.168.205.9:8443/auth/realms/master/ \
     --auth-provider-arg=client-id=local-kubernetes \
     --auth-provider-arg=refresh-token=${REFRESH_TOKEN} \
     --auth-provider-arg=idp-certificate-authority-data=${CLUSTER_CA_DATA}
