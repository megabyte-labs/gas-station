#!/usr/bin/env bash

# @file .start.sh
# @brief Ensures the project is up-to-date with the latest upstream changes
# @description
#   This script performs maintenance on this repository. It ensures the `.common` submodule is
#   cloned and up-to-date. The `.common` submodule contains files that are shared between projects
#   that are similar to this one. It also ensures the repository contains the latest code. This
#   script also ensures that our custom version of Task is installed and that its' location is
#   referenced by the PATH environment variable. `bash .start.sh` is the first command you should
#   run when working with this project.

set -eo pipefail

export REPO_TYPE="ansible"
export REPO_SUBTYPE="role"

# @description Set the `BASH_PROFILE` variable to the location of the bash initialization script and
# set the `SYSTEM` variable equal to a value indicating the type of system we are on.
if [[ "$OSTYPE" == 'darwin'* ]]; then
  BASH_PROFILE="$HOME/.bash_profile"
  SYSTEM="Darwin"
elif [[ "$OSTYPE" == 'linux-gnu'* ]]; then
  BASH_PROFILE="$HOME/.bashrc"
  SYSTEM="Linux"
elif [[ "$OSTYPE" == 'cygwin' ]]; then
  SYSTEM="Win64"
elif [[ "$OSTYPE" == 'msys' ]]; then
  SYSTEM="Win64"
elif [[ "$OSTYPE" == 'win32' ]]; then
  SYSTEM="Win32"
elif [[ "$OSTYPE" == 'freebsd'* ]]; then
  SYSTEM="FreeBSD"
else
  SYSTEM="Unknown"
fi

# @description Ensures ~/.local/bin is in the PATH variable on *nix machines
function ensureLocalPath() {
  if [ "$SYSTEM" == 'Darwin' ] || [ "$SYSTEM" == 'Linux' ]; then
    export PATH="$HOME/.local/bin:$PATH"
    # shellcheck disable=SC2016
    PATH_STRING='\nexport PATH=$HOME/.local/bin:$PATH'
    if grep -L "$PATH_STRING" "$BASH_PROFILE"; then
      echo -e "$PATH_STRING" >> "$BASH_PROFILE"
      echo "Updated the PATH variable to include ~/.local/bin in the $BASH_PROFILE file"
    fi
  elif [ "$SYSTEM" == 'Win32' ] || [ "$SYSTEM" == 'Win64' ]; then
    echo "Windows support not added yet"
  else
    echo "System type not recognized"
  fi
}

# @description Ensures Task is installed. It is installed to ~/.local/bin.
function installTask() {
  DOWNLOAD_DESTINATION=/tmp/megabytelabs/task.tar.gz
  if [ "$SYSTEM" == 'Darwin' ] || [ "$SYSTEM" == 'Linux' ]; then
    if [ "$SYSTEM" == 'Darwin' ]; then
      DOWNLOAD_SHA256=2cb230af13747d9c0dfa9cf2efa804770f581507fc49c0e92d2a5b82ce46a101
      DOWNLOAD_URL=https://github.com/go-task/task/releases/download/v3.7.3/task_darwin_amd64.tar.gz
    else
      DOWNLOAD_SHA256=5b30f9c042553141791ec753d2f96786c60a4968fd809f75bb0e8db6c6b4529b
      DOWNLOAD_URL=https://github.com/go-task/task/releases/download/v3.7.3/task_linux_amd64.tar.gz
    fi
    mkdir -p "$(dirname "$DOWNLOAD_DESTINATION")"
    wget "$DOWNLOAD_URL" -O "$DOWNLOAD_DESTINATION"
    sha256 "$DOWNLOAD_DESTINATION" "$DOWNLOAD_SHA256"
    mkdir "$TMP_DIR/task"
    tar -xzvf "$DOWNLOAD_DESTINATION" -C "$TMP_DIR/task"
    mv "$TMP_DIR/task" "$HOME/.local/bin/task"
    echo "Successfully installed Task to ~/.local/bin"
    rm "$DOWNLOAD_DESTINATION"
  elif [ "$SYSTEM" == 'Win32' ] || [ "$SYSTEM" == 'Win64' ]; then
    echo "Windows support not added yet"
    exit 1
  else
    echo "System type not recognized"
    exit 1
  fi
}

if [ -d .git ]; then
  git pull origin master --ff-only
  git submodule update --init --recursive
fi

if [ "$REPO_TYPE" != 'common' ]; then
  if [ ! -d .common ]; then
    git submodule add -b master "https://gitlab.com/megabyte-space/common/$REPO_TYPE.git" ".common"
  else
    cd .common
    git checkout master && git pull origin master --ff-only
    cd ..
  fi
  cp ".common/files-$REPO_SUBTYPE/Taskfile.yml" Taskfile.yml
fi

if ! type task &> /dev/null; then
  echo "Installing Task and ensuring ~/.local/bin is in the PATH environment variable"
  installTask &
  ensureLocalPath &
  wait
fi

rm -rf .task
task start

if [ "$REPO_TYPE" != 'common' ]; then
  cp ".common/files-$REPO_SUBTYPE/.start.sh" .start.sh &
fi
