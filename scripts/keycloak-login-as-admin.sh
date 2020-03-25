#!/bin/bash

PATH=/opt/keycloak/bin:$PATH

kcadm.sh config credentials \
    --server http://192.168.205.9:8080/auth \
    --realm master \
    --user admin \
    --password admin
