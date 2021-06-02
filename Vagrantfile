# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

Vagrant.configure("2") do |config|

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "main.yml"
    ansible.inventory_path = "inventories/vagrant.yml"
  end

  config.vm.define "archlinux" do |ubuntu|
    ubuntu.vm.box="Megabyte/Archlinux-Desktop"
    ubuntu.vm.hostname = "vagrant-archlinux"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52722, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52789, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52743, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52780, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.27", netmask: "255.255.255.0"
  end

  config.vm.define "centos" do |ubuntu|
    ubuntu.vm.box="Megabyte/CentOS-Desktop"
    ubuntu.vm.hostname = "vagrant-centos"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52622, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52689, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52643, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52680, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.26", netmask: "255.255.255.0"
  end

  config.vm.define "debian" do |ubuntu|
    ubuntu.vm.box="Megabyte/Debian-Desktop"
    ubuntu.vm.hostname = "vagrant-debian"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52522, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52589, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52543, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52580, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.25", netmask: "255.255.255.0"
  end

  config.vm.define "fedora" do |ubuntu|
    ubuntu.vm.box="Megabyte/Fedora-Desktop"
    ubuntu.vm.hostname = "vagrant-fedora"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52422, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52489, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52443, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52480, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.24", netmask: "255.255.255.0"
  end

  config.vm.define "macos" do |ubuntu|
    ubuntu.vm.box="Megabyte/macOS-Desktop"
    ubuntu.vm.hostname = "vagrant-macos"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52322, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52389, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52343, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52380, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.23", netmask: "255.255.255.0"
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box="Megabyte/Ubuntu-Desktop"
    ubuntu.vm.hostname = "vagrant-ubuntu"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52222, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52289, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52243, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52280, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.22", netmask: "255.255.255.0"
  end

  config.vm.define "windows" do |ubuntu|
    ubuntu.vm.box="Megabyte/Windows-Desktop"
    ubuntu.vm.hostname = "vagrant-windows"
    ubuntu.vm.network "forwarded_port", guest: 22, host: 52122, id: "ssh", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 3389, host: 52189, id: "rdp", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 443, host: 52143, id: "https", auto_correct: true
    ubuntu.vm.network "forwarded_port", guest: 80, host: 52180, id: "http", auto_correct: true
    ubuntu.vm.network "private_network", ip: "172.24.24.21", netmask: "255.255.255.0"
  end
end
