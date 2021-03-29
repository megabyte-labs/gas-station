#!/bin/bash
cd ~ || { echo "$0: Directory do not exist"; exit 1; }
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev sshpass
sudo dpkg-reconfigure openssh-server
pip3 install pywinrm\[credssp\]
git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
chmod 700 Playbooks
sudo sed -i 's/#Port 22/Port 2214/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service ssh restart
# ansible-playbook --ask-vault-pass main.yml
