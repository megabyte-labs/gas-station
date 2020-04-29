#!/bin/bash
sudo apt-get update
sudo apt-get install python-pip git libffi-dev libssl-dev -y
pip install ansible pywinrm
ansible-playbook -k main.yml