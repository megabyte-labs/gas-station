#!/bin/bash
sudo apt install ansible
cd ~
git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
cd ~/Playbooks
mkdir -p ~/.config/autostart
cp ~/Playbooks/files/ubuntu/ansible-installer.desktop ~/.config/autostart/ansible-installer.desktop
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass -i inventories/workstation.yml start.yml
