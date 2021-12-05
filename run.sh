#!/bin/bash

sudo dnf -y install python3-pip
pip3 install ansible
mkdir -p ~/.ansible/roles
find ./roles -mindepth 2 -maxdepth 2 -type d -print0 | while read -d $'\0' ROLE_PATH; do ROLE_FOLDER="$(echo professormanhattan.$(basename $ROLE_PATH))"; if [ ! -d "~/.ansible/roles/$ROLE_FOLDER" ]; then echo "$PWD/$ROLE_PATH"; ln -sf "$PWD/$ROLE_PATH" "$HOME/.ansible/roles/$ROLE_FOLDER"; fi; done
ansible-playbook -i inventories/workstation.yml --vault-pass-file pass main.yml