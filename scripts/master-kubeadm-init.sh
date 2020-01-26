#!/bin/bash

echo "=== kubeadm init"
IP_ADDR=`ifconfig enp0s8 | grep inet  | awk '{print $2}'| cut -f2 -d:`

HOST_NAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=$IP_ADDR \
             --apiserver-cert-extra-sans=$IP_ADDR  \
             --node-name $HOST_NAME \
             --pod-network-cidr=172.16.0.0/16
