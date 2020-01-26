servers = [
    { :name => "master", :type => "master" },
    { :name => "node-1", :type => "node" },
    { :name => "node-2", :type => "node" }
]

Vagrant.configure("2") do |config|
    ip_suffix = 10
    ip_prefix = "192.168.205"

    config.vm.box = "ubuntu-k8s-base"
    config.vm.box_version = 0

    cluster_name = "kubernetes"
    servers.each do |server|
        server_full_name = "#{server[:name]}"
        config.vm.define server_full_name do |config|
            ip = "#{ip_prefix}.#{ip_suffix}"
            config.vm.hostname = server_full_name
            config.vm.network :private_network, ip: ip
            ip_suffix = ip_suffix + 1

            config.vm.provider "virtualbox" do |v|
                v.name = server_full_name
                v.customize ["modifyvm", :id, "--groups", "/#{cluster_name}"]
                v.customize ["modifyvm", :id, "--memory", 2048]
                v.customize ["modifyvm", :id, "--cpus", 2]
            end

            config.vm.provision "shell", path: "scripts/common-kubelet-node-ip.sh"

            if server[:type] == "master"
                config.vm.provision "shell", path: "scripts/master-kubeadm-init.sh"
                config.vm.provision "shell", path: "scripts/master-kube-config-setup.sh"
                config.vm.provision "shell", path: "scripts/master-calico.sh", privileged: false
                config.vm.provision "shell", path: "scripts/master-kubeadm-token.sh", args: cluster_name
                config.vm.provision "shell", path: "scripts/master-metallb.sh", privileged: false
            else
                config.vm.provision "shell", path: "tmp/join-#{cluster_name}.sh"
            end
        end
    end
end
