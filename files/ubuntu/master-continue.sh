#!/bin/bash
cd ~/Playbooks || { echo "$0: Directory do not exist"; exit 1; }
ansible-playbook --vault-password-file=.vault_pass -i inventories/workstation.yml main.yml
