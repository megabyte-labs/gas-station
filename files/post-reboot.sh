#!/bin/bash
cd ~/Playbooks
ansible-playbook --vault-password-file=~/.vault_pass -i inventories/workstation.yml main.yml
