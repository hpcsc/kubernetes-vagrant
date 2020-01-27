#!/bin/bash

echo "=== Installing common tools"

apt-get update
apt-get install -y apt-transport-https \
                   ca-certificates \
                   curl \
                   software-properties-common \
                   jq
