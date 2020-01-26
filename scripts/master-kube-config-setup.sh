#!/bin/bash

USER_HOME=/home/vagrant
echo "=== Copying admin.conf to $USER_HOME/.kube/config"

mkdir -p $USER_HOME/.kube
cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
sudo chown $(id -u vagrant):$(id -g vagrant) $USER_HOME/.kube/config
