#!/bin/bash

cd ~/Playbooks || exit
ansible-playbook --ask-sudo-pass -i inventories/quickstart.yml main.yml
