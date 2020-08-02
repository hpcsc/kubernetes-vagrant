#!/bin/bash

USER_HOME=/home/vagrant
echo "=== Copying admin.conf to $USER_HOME/.kube/config"

mkdir -p $USER_HOME/.kube
cp -vf /etc/kubernetes/admin.conf $USER_HOME/.kube/config
sudo chown $(id -u vagrant):$(id -g vagrant) $USER_HOME/.kube/config

echo "=== Copying admin.conf to /vagrant/tmp"
cp -vf /etc/kubernetes/admin.conf /vagrant/tmp/admin.conf
