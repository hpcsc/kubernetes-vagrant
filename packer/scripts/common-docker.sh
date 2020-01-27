#!/bin/bash

echo "=== Installing Docker"
DOCKER_CE_VERSION=5:19.03.5~3-0

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce=${DOCKER_CE_VERSION}~ubuntu-$(lsb_release -cs)

# add vagrant user to docker group
usermod -aG docker vagrant
