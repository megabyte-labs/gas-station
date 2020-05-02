#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git ansible python3-pip libffi-dev libssl-dev -y
pip3 install pywinrm[credssp]
git clone https://gitlab.com/ProfessorManhattan/playbooks.git $HOME/ProfessorManhattan
chmod 755 $HOME/ProfessorManhattan/windows
ansible-playbook $HOME/ProfessorManhattan/windows/main.yml
