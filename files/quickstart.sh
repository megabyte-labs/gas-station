#!/bin/bash

# Install dependencies based on OS family
if [ "$(uname)" == "Darwin" ]; then
  # System is Mac OS X
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install git python
elif [ -f "/etc/redhat-release" ]; then
  # System is RedHat-based
  sudo yum update
  sudo yum install git python3 python3-pip
elif [ -f "/etc/lsb-release" ]; then
  # System is Debian-based
  sudo apt update
  sudo apt install -y git python3 python3-pip
elif [ -f "/etc/arch-release" ]; then
  # System is Archlinux
  sudo pacman update
  sudo pacman -S git python3 python3-pip
fi

# Run WSL-specific tasks
if grep -q Microsoft /proc/version; then
  # Bash is running on WSL
  # TODO: Add logic here for WSL
  exit
fi

# Install Ansible
pip3 install ansible

# Clone the repository
cd ~ || exit
if [ ! -d ~/Playbooks ]; then
  git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
fi

# Install the Ansible requirements and run the playbook
cd ~/Playbooks || exit
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass -i inventories/workstation.yml --skip-tags "skip_on_init" playbooks/workstation.yml
