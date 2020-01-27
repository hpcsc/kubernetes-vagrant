#!/bin/bash

rm -f ./tmp/config ./tmp/config.merged

mkdir -p ./tmp

scp -P $(vagrant port master --guest 22) vagrant@127.0.0.1:/home/vagrant/.kube/config ./tmp

KUBECONFIG=~/.kube/config:./tmp/config kubectl config view --flatten > ./tmp/config.merged
