#!/usr/bin/env bash

# @file .config/scripts/lib/package.sh
# @brief Either shows a warning message or makes an effort to ensure a basic package is available

set -eo pipefail

# @description Ensures a given package is installed on a system. It will check if
# the package is already present and then attempt to install it if it is not. The
# installation will only occur on Linux systems (other systems report an error if the
# package is missing).
#
# @example
#   ensurePackageInstalled "curl"
#
# @arg $1 string The name of the package that must be present
#
# @exitcode 0 If the package is already present or if it successfully installs
# @exitcode 1+ If the package needs to be installed manually or if the OS is unsupported
function ensurePackageInstalled() {
  if ! type "$1" &> /dev/null; then
    if [[ "$OSTYPE" == 'darwin'* ]]; then
      echo "$1 appears to be missing. Please install $1 to continue" && exit 1
    elif [[ "$OSTYPE" == 'linux-gnu'* ]]; then
      if [ -f "/etc/redhat-release" ]; then
        sudo yum update
        sudo yum install "$1"
      elif [ -f "/etc/lsb-release" ]; then
        sudo apt update
        sudo apt install -y "$1"
      elif [ -f "/etc/arch-release" ]; then
        sudo pacman update
        sudo pacman -S "$1"
      else
        . .config/log error "$1 is missing. Please install $1 to continue." && exit 1
      fi
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      . .config/log error "Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      . .config/log error "FreeBSD support not added yet" && exit 1
    else
      . .config/log error "System type not recognized" && exit 1
    fi
  fi
}

ensurePackageInstalled "$1"
