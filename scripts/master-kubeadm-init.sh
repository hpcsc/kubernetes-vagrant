#!/bin/bash

IP_ADDR=`ifconfig enp0s8 | grep inet  | awk '{print $2}'| cut -f2 -d:`
cp -vf /vagrant/kubeadm-config.yml /tmp
echo "=== replace master IP address in /tmp/kubeadm-config.yml with ${IP_ADDR}"
sed -i 's/${MASTER_IP_ADDRESS}/'${IP_ADDR}'/g' /tmp/kubeadm-config.yml

echo "=== use custom ca key and cert (from keycloak) as kubernetes ca"
mkdir -p /etc/kubernetes/pki
cp -vf /vagrant/tmp/ca.{key,crt} /etc/kubernetes/pki/

echo "=== update server CA certificates"
cp -v /etc/kubernetes/pki/ca.crt /usr/local/share/ca-certificates/
update-ca-certificates

HOST_NAME=$(hostname -s)
echo "=== kubeadm init for ${HOST_NAME}"
kubeadm init --node-name $HOST_NAME \
             --config /tmp/kubeadm-config.yml
