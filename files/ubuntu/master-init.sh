#!/bin/bash
sudo apt update
sudo apt install -y git python3 python3-pip python3-netaddr
sudo python3 -m pip install ansible psutil
cd ~ || { echo "$0: Directory do not exist"; exit 1; }
if [ ! -d ~/Playbooks ] ; then
    git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
fi
cd ~/Playbooks || { echo "$0: Directory do not exist"; exit 1; }
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass -i inventories/workstation.yml --skip-tags "skip_on_init" start.yml
