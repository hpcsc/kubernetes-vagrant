#!/bin/bash

CLUSTER_NAME=$1
echo "=== Generating join-cluster.sh script for cluster $CLUSTER_NAME"
mkdir -p /vagrant/tmp
kubeadm token create --print-join-command > /vagrant/tmp/join-$CLUSTER_NAME.sh
chmod +x /vagrant/tmp/join-$CLUSTER_NAME.sh
