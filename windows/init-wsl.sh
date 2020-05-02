#!/bin/bash
git_repo=https://gitlab.com/ProfessorManhattan/playbooks.git
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git ansible python3-pip libffi-dev libssl-dev -y
pip3 install pywinrm[credssp]
# Needs to be on one line due to Powershell adding /r to end of everything
rm -rf $HOME/ProfessorManhattan && git clone $git_repo $HOME/ProfessorManhattan && chmod 755 $HOME/ProfessorManhattan/windows && pushd $HOME/ProfessorManhattan/windows && ansible-playbook main.yml
