#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git ansible python3-pip libffi-dev libssl-dev -y
pip3 install pywinrm[credssp]
cd ~
git clone https://gitlab.com/ProfessorManhattan/playbooks.git
cd playbooks
chmod 755 windows
cd windows
ansible-playbook main.yml