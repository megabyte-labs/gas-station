# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

Vagrant.configure("2") do |config|

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "main.yml"
    ansible.inventory_path = "inventories/vagrant.yml"
  end

  config.vm.define "vagrant-ubuntu" do |ubuntu|
    ubuntu.vm.box="Megabyte/Ubuntu-Desktop"
    ubuntu.vm.hostname = "vagrant-ubuntu"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 58022, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 53389, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 58443, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 58080, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.2", netmask: "255.255.255.0"

    ubuntu.vm.provider "virtualbox" do |v|
      v.check_guest_additions = true
      v.customize ["modifyvm", :id, "--accelerate3d", "on"]
      v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      v.customize ["modifyvm", :id, "--cpus", "4"]
      v.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
      v.customize ["modifyvm", :id, "--hwvirtex", "on"]
      v.customize ["modifyvm", :id, "--memory", "4096"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--vram", "256"]
      v.customize ["setextradata", "global", "GUI/SuppressMessages", "all"]
      v.memory = 4096
      v.cpus = 2
    end
  end
end
