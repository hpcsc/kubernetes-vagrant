#!/bin/bash

echo "=== Installing calico"
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
