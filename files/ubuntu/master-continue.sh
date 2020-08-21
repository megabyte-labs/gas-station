#!/bin/bash
cd ~/Playbooks
rm ~/.config/autostart/ansible-installer.desktop
ansible-playbook --ask-vault-pass -i inventories/workstation.yml main.yml
