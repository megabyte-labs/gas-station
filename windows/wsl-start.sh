#!/bin/bash
sudo apt-get update
sudo apt-get install ansible git python3-pip libffi-dev libssl-dev -y
pip3 install pywinrm
ansible-playbook -k main.yml