#!/bin/bash

rm -f ./tmp/config.merged

KUBECONFIG=~/.kube/config:./tmp/admin.conf kubectl config view --flatten > ./tmp/config.merged
