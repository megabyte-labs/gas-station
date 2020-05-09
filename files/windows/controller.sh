#!/bin/bash
cd ~
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev
sudo dpkg-reconfigure openssh-server
pip3 install pywinrm[credssp]
git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
chmod 700 Playbooks
cd Playbooks
ansible-playbook main.yml