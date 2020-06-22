def define_kubernetes_cluster(cluster_name, servers, config)
    ip_suffix = 10
    ip_prefix = "192.168.205"

    servers.each do |server|
        server_full_name = "#{server[:name]}"
        config.vm.define server_full_name do |server_config|
            server_config.vm.box = "hpcsc/ubuntu-k8s-base"
            server_config.vm.box_version = "0.1.0"
            server_config.vm.hostname = server_full_name

            ip = "#{ip_prefix}.#{ip_suffix}"
            server_config.vm.network :private_network, ip: ip
            ip_suffix = ip_suffix + 1

            server_config.vm.provider "virtualbox" do |v|
                v.name = server_full_name
                v.customize ["modifyvm", :id, "--groups", "/#{cluster_name}"]
                v.customize ["modifyvm", :id, "--memory", 2048]
                v.customize ["modifyvm", :id, "--cpus", 2]
            end

            server_config.vm.provision "shell", path: "scripts/common-kubelet-node-ip.sh"

            if server[:type] == "master"
                server_config.vm.provision "shell", path: "scripts/master-kubeadm-init.sh"
                server_config.vm.provision "shell", path: "scripts/master-kube-config-setup.sh"
                server_config.vm.provision "shell", path: "scripts/master-calico.sh", privileged: false
                server_config.vm.provision "shell", path: "scripts/master-kubeadm-token.sh", args: cluster_name
                server_config.vm.provision "shell", path: "scripts/master-metallb.sh", privileged: false
            else
                server_config.vm.provision "shell", path: "tmp/join-#{cluster_name}.sh"
            end
        end
    end
end

def define_keycloak(cluster_name, config)
    name = "keycloak"

    config.vm.define name do |keycloak|
        keycloak.vm.box = "ubuntu/bionic64"
        keycloak.vm.hostname = name

        ip = "192.168.205.9"
        keycloak.vm.network :private_network, ip: ip

        keycloak.vm.provider "virtualbox" do |v|
            v.name = name
            v.customize ["modifyvm", :id, "--groups", "/#{cluster_name}"]
            v.customize ["modifyvm", :id, "--memory", 2048]
            v.customize ["modifyvm", :id, "--cpus", 2]
        end

        keycloak.vm.provision "shell", path: "scripts/keycloak-java.sh"
        keycloak.vm.provision "shell", path: "scripts/keycloak-install.sh", args: ip
        keycloak.vm.provision "shell", path: "scripts/keycloak-generate-cert.sh"
        keycloak.vm.provision "shell", path: "scripts/keycloak-wait-server-up.sh", args: ip
        keycloak.vm.provision "shell", path: "scripts/keycloak-create-client.sh", args: "local-kubernetes"
        keycloak.vm.provision "shell", path: "scripts/keycloak-create-group.sh", args: "Developers"
        keycloak.vm.provision "shell", path: "scripts/keycloak-create-user.sh", args: ["dev-1", "Developers"]
    end
end

Vagrant.configure("2") do |config|
    cluster_name = "kubernetes"

    if ! File.file?("./tmp/ca.crt")
      system("./certs/generate-ca-certs.sh")
    end

    define_keycloak(cluster_name, config)

    servers = [
        { :name => "master", :type => "master" },
        { :name => "node-1", :type => "node" },
        { :name => "node-2", :type => "node" }
    ]
    define_kubernetes_cluster(cluster_name, servers, config)
end
