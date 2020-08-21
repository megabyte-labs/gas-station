#!/bin/bash
cd ~/Playbooks
rm ~/.config/autostart/ansible-installer.desktop
ansible-playbook --vault-password-file=.vault_pass -i inventories/workstation.yml main.yml
