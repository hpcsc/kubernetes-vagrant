#!/bin/bash

HOST_IP=$1
PORT=8080
HOST_URL="http://${HOST_IP}:${PORT}"

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
