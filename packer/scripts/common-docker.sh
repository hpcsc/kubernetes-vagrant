#!/bin/bash

echo "=== Installing Docker"
sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common jq
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && apt-cache policy docker-ce && sudo apt install -y docker-ce=5:18.09.6~3-0~ubuntu-$(lsb_release -cs)

# add vagrant user to docker group
usermod -aG docker vagrant
