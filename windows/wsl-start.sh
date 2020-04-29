#!/bin/bash
sudo apt-get update
sudo apt-get install python3-pip git libffi-dev libssl-dev -y
pip3 install ansible pywinrm
ansible-playbook -k main.yml