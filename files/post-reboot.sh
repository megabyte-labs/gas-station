#!/bin/bash
cd ~/Playbooks || exit
ansible-playbook --vault-password-file=~/.vault_pass -i inventories/workstation.yml main.yml
