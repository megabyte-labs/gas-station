#!/bin/bash
sudo apt update
sudo apt install -y git python3 python3-pip
sudo python3 -m pip install ansible
cd ~
if [ ! -d ~/Playbooks ] ; then
    git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
fi
cd ~/Playbooks
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass -i inventories/workstation.yml --skip-tags "skip_on_init" start.yml
