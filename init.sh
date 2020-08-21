#!/bin/bash
sudo apt install ansible
cd ~/Playbooks
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass -i inventories/workstation.yml main.yml
