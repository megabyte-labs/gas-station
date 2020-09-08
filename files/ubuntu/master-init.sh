#!/bin/bash
sudo apt update
sudo apt install -y ansible git
cd ~
git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
cd ~/Playbooks
mkdir -p ~/.config/autostart
cp ~/Playbooks/files/ubuntu/ansible-installer.desktop ~/.config/autostart/ansible-installer.desktop
chmod 700 ~/Playbooks/files/ubuntu/master-continue.sh
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass -i inventories/workstation.yml start.yml
#sudo reboot
