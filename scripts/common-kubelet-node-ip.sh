#!/bin/bash

IP_ADDR=`ifconfig enp0s8 | grep inet  | awk '{print $2}'| cut -f2 -d:`
echo "=== IP: $IP_ADDR, creating /etc/default/kubelet"
echo "KUBELET_EXTRA_ARGS=--node-ip=${IP_ADDR}" > /etc/default/kubelet # set node IP

sudo systemctl restart kubelet
