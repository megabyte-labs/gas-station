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

# @description The folder to store the Playbook files in the current user's home directory
PLAYBOOKS_DIR="Playbooks"

# @description Ensures given package is installed on a system.
#
# @example
#   ensurePackageInstalled "curl"
#
# @arg $1 string The name of the package that must be present
#
# @exitcode 0 The package(s) were successfully installed
# @exitcode 1+ If there was an error, the package needs to be installed manually, or if the OS is unsupported
function ensurePackageInstalled() {
  if ! type "$1" &> /dev/null; then
    if [[ "$OSTYPE" == 'darwin'* ]]; then
      brew install "$1"
    elif [[ "$OSTYPE" == 'linux'* ]]; then
      if [ -f "/etc/redhat-release" ]; then
        if type sudo &> /dev/null; then
          if type dnf &> /dev/null; then
            sudo dnf install -y "$1"
          else
            sudo yum install -y "$1"
          fi
        else
          if type dnf &> /dev/null; then
            dnf install -y "$1"
          else
            yum install -y "$1"
          fi
        fi
      elif [ -f "/etc/ubuntu-release" ] || [ -f "/etc/debian_version" ]; then
        if type sudo &> /dev/null; then
          sudo apt-get update
          sudo apt-get install -y "$1"
        else
          apt-get update
          apt-get install -y "$1"
        fi
      elif [ -f "/etc/arch-release" ]; then
        if type sudo &> /dev/null; then
          sudo pacman update
          sudo pacman -S "$1"
        else
          pacman update
          pacman -S "$1"
        fi
      elif [ -f "/etc/alpine-release" ]; then
        if type sudo &> /dev/null; then
          sudo apk --no-cache add "$1"
        else
          apk --no-cache add "$1"
        fi
      else
        echo "ERROR: $1 is missing. Please install $1 to continue." && exit 1
      fi
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      echo "ERROR: Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      echo "ERROR: FreeBSD support not added yet" && exit 1
    else
      echo "System type not recognized"
    fi
  fi
}

# @description Clone the repository if `git` is available, otherwise, use `curl` and `tar`. Also,
# if the repository is already cloned then attempt to pull the latest changes if `git` is installed.
cd ~ || exit
if [ ! -d "$HOME/$PLAYBOOKS_DIR" ]; then
  if [ "$USER" == 'root' ]; then
    echo "You should not run this as the root user. Try again with a non-root user that preferrably has sudo privileges." && exit 1
  else
    ensurePackageInstalled "curl"
    ensurePackageInstalled "git"
    git clone https://gitlab.com/megabyte-labs/gas-station.git "$PLAYBOOKS_DIR"
  fi
fi

# @description Ensure Task is installed and properly configured and then run the `ansible:quickstart`
# task. The source to the `ansible:quickstart` task can be found
# [here](https://gitlab.com/megabyte-labs/common/shared/-/blob/master/common/.config/taskfiles/ansible/Taskfile.yml).
cd "$HOME/$PLAYBOOKS_DIR" || exit
bash start.sh
task ansible:quickstart
