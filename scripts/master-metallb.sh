#!/bin/bash

echo "=== Installing MetalLB"
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml

echo "=== Creating MetalLB config"
kubectl apply -f /vagrant/metallb-config.yaml
