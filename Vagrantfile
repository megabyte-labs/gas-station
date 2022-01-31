# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

nodes = [
  { :hostname => 'centos', :ip => '10.14.14.246', :box => 'Megabyte/CentOS-Desktop', :ssh_port => 52422, :auto_config => false },
  { :hostname => 'debian', :ip => '10.14.14.245', :box => 'Megabyte/Debian-Desktop', :ssh_port => 52322, :auto_config => false },
  { :hostname => 'fedora', :ip => '10.14.14.244', :box => 'Megabyte/Fedora-Desktop', :ssh_port => 52222, :auto_config => false },
  { :hostname => 'ubuntu', :ip => '10.14.14.242', :box => 'Megabyte/Ubuntu-Desktop', :ssh_port => 52022, :auto_config => false },
  { :hostname => 'windows', :ip => '10.14.14.241', :box => 'Megabyte/Windows-Desktop', :ssh_port => 52622, :auto_config => true, :ram => 4096, :windows => true }
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]

      nodeconfig.vm.network :public_network, ip: node[:ip], type: "dhcp", auto_config: node[:auto_config]
      nodeconfig.vm.network :forwarded_port, guest: 22, host: node[:ssh_port], id: "ssh", auto_correct: false
      nodeconfig.vm.network :forwarded_port, guest: 80, host: 52080, id: "http", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 443, host: 52443, id: "https", auto_correct: true
      nodeconfig.vm.network :forwarded_port, guest: 3389, host: 53389, id: "rdp", auto_correct: true
      if node[:windows] == true; then
        nodeconfig.vm.network :forwarded_port, guest: 5985, host: 55985, id: "winrm", auto_correct: false
      end

      memory = node[:ram] ? node[:ram] : 2048
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.gui = true
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "50",
          "--memory", memory.to_s
        ]
      end

      nodeconfig.vm.guest = node[:windows] ? :windows : :linux
      nodeconfig.vm.communicator = node[:windows] ? :winrm : :ssh

      nodeconfig.ssh.username = "vagrant"
      nodeconfig.ssh.password = "vagrant"
      nodeconfig.ssh.insert_key = true

      nodeconfig.winrm.username = "vagrant"
      nodeconfig.winrm.password = "vagrant"
    end
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "main.yml"
    ansible.inventory_path = "inventories/vagrant.yml"
  end
end
