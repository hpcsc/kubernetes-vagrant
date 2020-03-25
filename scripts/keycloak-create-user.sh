#!/bin/bash -e

USER_NAME=$1
GROUP_NAME=$2

if [ -z "${USER_NAME}" ] || [ -z "${GROUP_NAME}" ]; then
    echo "=== user name and group name are required"
    echo "Usage: $0 user-name group-name"
    exit 1
fi;

source /vagrant/scripts/keycloak-login-as-admin.sh

function get_user_by_name() {
    local username=$1
    kcadm.sh get users | jq -r '.[] | select(.username == "'${username}'") | .id'
}

function get_group_by_name() {
    local group_name=$1
    kcadm.sh get groups | jq -r '.[] | select(.name == "'${group_name}'") | .id'
}

if [ -z "$(get_user_by_name ${USER_NAME})" ]; then
    echo "=== Creating user ${USER_NAME}"
    kcadm.sh create users -s username=${USER_NAME} -s enabled=true
    kcadm.sh set-password --username ${USER_NAME} -p password.123
else
    echo "=== User ${USER_NAME} exists"
fi

USER_ID=$(get_user_by_name ${USER_NAME})

if [ -z "$(kcadm.sh get users/${USER_ID}/groups | jq -r '.[] | select(.name == "'${GROUP_NAME}'") | .id')" ]; then
    echo "=== Adding user ${USER_NAME} to group ${GROUP_NAME}"
    GROUP_ID=$(get_group_by_name ${GROUP_NAME})
    kcadm.sh update users/${USER_ID}/groups/${GROUP_ID}
else
    echo "=== User ${USER_NAME} already belongs to group ${GROUP_NAME}"
fi
