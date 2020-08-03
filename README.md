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

## Step 4: Setup keycloak

- As kubernetes admin, execute: `kubectl apply -f ./sample-role-bindings/group-role-binding.yml` to create role binding for `Developer` group.

### Get refresh token manually from keycloak

- Execute `./set-keycloak-user-kubectl.sh` to add another user (`dev-1`, who belongs to `Developer` group) to your kubectl config. This will setup kubectl to get identity token from keycloak sending any command to kubernetes cluster.
- Use this new user in your current context
- You will need to refresh the refresh token periodically (by executing `./set-keycloak-user-kubectl.sh` again) when the refresh token expires.

### Use kubelogin

This [kubectl plugin](https://github.com/int128/kubelogin) can simplify the process of getting identity token from keycloak (and refresh it automatically)

To use it:

- Install the plugin
- Note down client secret value from `keycloak-local-kubernetes.secret`
- Add the following user config to your kubectl config:

```
- name: kubernetes-vagrant-dev-1
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: kubectl
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=https://192.168.205.9:8443/auth/realms/master
      - --oidc-client-id=local-kubernetes
      - --oidc-client-secret=CLIENT_SECRET_NOTED_ABOVE
```

- Use this new user in your current context. When executing any kubectl command for the first time, kubelogin will open browser with keycloak login UI. Log in using username/password: `dev-1`/`password.123`
