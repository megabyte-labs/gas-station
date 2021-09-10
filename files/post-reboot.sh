#!/bin/bash

cd ~/Playbooks || exit
ansible-playbook --vault-password-file=~/.vault_pass -i inventories/laptop.yml main.yml
