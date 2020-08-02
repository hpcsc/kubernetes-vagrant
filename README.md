# Kubernetes cluster

Vagrant and Packer scripts to setup a local Kubernetes cluster in VirtualBox

This setup is based on [https://github.com/ecomm-integration-ballerina/kubernetes-cluster](https://github.com/ecomm-integration-ballerina/kubernetes-cluster)

It uses [MetalLB](https://metallb.universe.tf/configuration/#layer-2-configuration) (Layer 2 Configuration) to provides network load-balancer

## Step 1 (optional): Build base Vagrant box using Packer

`Vagrantfile` already uses pre-built Vagrant box hosted in vagrant cloud. If you want to build the box yourself, follow instruction below.

This creates a Vagrant box based on Ubuntu 18.04 with common tools used by both Kubernetes master and worker nodes like docker, kubectl etc

```
cd packer
packer build ubuntu-k8s-base.json
```

Note: the command will seem to be hanging at "Waiting for SSH to become available." but it just takes a long time (5-10 mins)

## Step 2: Vagrant up

```
vagrant box add ubuntu-k8s-base ${PWD}/builds/ubuntu-18.04.virtualbox.box
vagrant up
```

## Step 3: Get admin user config file from master node

admin config file from master node is copied to `./tmp/admin.conf` once cluster is up

Execute following script to merge this `admin.conf` file with your existing config file from `~/.kube/config` and output to `./tmp/config.merged` file

```
./merge-kube-config.sh
```

Move `tmp/config.merged` to `~/.kube/config` to start interacting with the cluster
