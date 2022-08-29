#!/usr/bin/env bash

# @file files/quickstart.sh
# @brief Installs the playbook on the local machine with little, if any, input required
# @description
#   This script will run the `ansible:quickstart` task on the local machine without much input
#   required by the user. The `ansible:quickstart` task installs the entire playbook. It should
#   certainly be run in a VM before running it on your main computer to test whether or not you
#   like the changes. It will ask you for your sudo password at the beginning of the play and
#   after any reboots that are required. The sudo password will also be required to ensure Ansible
#   dependencies are installed prior to the playbook running.

set -eo pipefail

# @description Detect script paths
BASH_SRC="$(dirname "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(cd "$BASH_SRC"; pwd -P)"
INSTALL_PACKAGE_SCRIPT="$SOURCE_PATH/../.config/scripts/lib/package.sh"
INSTALL_TASK_SCRIPT="$SOURCE_PATH/../.config/scripts/lib/task.sh"

# @description The folder to store the Playbook files in the current user's home directory
PLAYBOOKS_DIR="Playbooks"

# @description Clone the repository if `git` is available, otherwise, use `curl` and `tar`. Also,
# if the repository is already cloned then attempt to pull the latest changes if `git` is installed.
cd ~ || exit
if [ ! -d "$HOME/$PLAYBOOKS_DIR" ]; then
  if type git &> /dev/null; then
    git clone https://gitlab.com/ProfessorManhattan/Playbooks.git "$PLAYBOOKS_DIR"
  else
    bash "$INSTALL_PACKAGE_SCRIPT" "curl"
    curl https://gitlab.com/ProfessorManhattan/Playbooks/-/archive/master/Playbooks-master.tar.gz -o Playbooks.tar.gz
    bash "$INSTALL_PACKAGE_SCRIPT" "tar"
    tar -xzvf Playbooks.tar.gz
    mv Playbooks-master "$PLAYBOOKS_DIR"
  fi
else
  if type git &> /dev/null; then
    if [ -d "$HOME/$PLAYBOOKS_DIR/.git" ]; then
      cd "$HOME/$PLAYBOOKS_DIR"
      git pull origin master --ff-only
      git submodule update --init --recursive
      cd ..
    fi
  fi
fi

# @description Ensure Task is installed and properly configured and then run the `ansible:quickstart`
# task. The source to the `ansible:quickstart` task can be found
# [here](https://gitlab.com/megabyte-labs/common/shared/-/blob/master/common/.config/taskfiles/ansible/Taskfile.yml).
cd "$HOME/$PLAYBOOKS_DIR" || exit
bash "$INSTALL_TASK_SCRIPT"
task ansible:quickstart
