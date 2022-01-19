#!/usr/bin/env bash

# @file .config/scripts/start.sh
# @brief Ensures Task is installed and up-to-date and then runs `task start`
# @description
#   This script will ensure [Task](https://github.com/go-task/task) is up-to-date
#   and then run the `start` task which is generally a good entrypoint for any repository
#   that is using the Megabyte Labs templating/taskfile system. The `start` task will
#   ensure that the latest upstream changes are retrieved, that the project is
#   properly generated with them, and that all the development dependencies are installed.

set -eo pipefail

# @description Ensure .config/log is executable
if [ -f .config/log ]; then
  chmod +x .config/log
fi

# @description Detect script paths
BASH_SRC="$(dirname "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(
  cd "$BASH_SRC"
  pwd -P
)"
PROJECT_BASE_DIR="$SOURCE_PATH/../.."
INSTALL_PACKAGE_SCRIPT="$SOURCE_PATH/lib/package.sh"
INSTALL_TASK_SCRIPT="$SOURCE_PATH/lib/task.sh"
TMP_PROFILE_PATH="$(mktemp)"
VALID_TASKFILE_SCRIPT="$SOURCE_PATH/lib/taskfile.sh"

# @description Ensures ~/.local/bin is in the PATH variable on *nix machines and
# exits with an error on unsupported OS types
#
# @example
#   ensureLocalPath
#
# @set PATH string The updated PATH with a reference to ~/.local/bin
# @set SHELL_PROFILE string The preferred profile
#
# @noarg
#
# @exitcode 0 If the PATH was appropriately updated or did not need updating
# @exitcode 1+ If the OS is unsupported
function ensureLocalPath() {
  case "${SHELL}" in
    */bash*)
      if [[ -r "${HOME}/.bash_profile" ]]; then
        SHELL_PROFILE="${HOME}/.bash_profile"
      else
        SHELL_PROFILE="${HOME}/.profile"
      fi
      ;;
    */zsh*)
      SHELL_PROFILE="${HOME}/.zshrc"
      ;;
    *)
      SHELL_PROFILE="${HOME}/.profile"
      ;;
  esac
  if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]]; then
    # shellcheck disable=SC2016
    local PATH_STRING='PATH="$HOME/.local/bin:$PATH"'
    mkdir -p "$HOME/.local/bin"
    if grep -L "$PATH_STRING" "$SHELL_PROFILE"; then
      echo -e "export ${PATH_STRING}\n" >> "$SHELL_PROFILE"
      echo "$SHELL_PROFILE" > "$TMP_PROFILE_PATH"
      .config/log info "Updated the PATH variable to include ~/.local/bin in $SHELL_PROFILE"
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    .config/log error "Windows is not directly supported. Use WSL or Docker." && exit 1
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    .config/log error "FreeBSD support not added yet" && exit 1
  else
    .config/log error "System type not recognized"
  fi
}
ensureLocalPath

# @description Ensure basic dependencies are installed
bash "$INSTALL_PACKAGE_SCRIPT" "curl"
bash "$INSTALL_PACKAGE_SCRIPT" "git"

# @description Attempts to pull the latest changes if the folder is a git repository
cd "$PROJECT_BASE_DIR" || exit
if [ -d .git ] && type git &> /dev/null; then
  HTTPS_VERSION="$(git remote get-url origin | sed 's/git@gitlab.com:/https:\/\/gitlab.com\//')"
  git pull "$HTTPS_VERSION" master --ff-only
  git submodule update --init --recursive
fi

# @description Ensures Task is installed and properly configured
if [ "$GITLAB_CI" != 'true' ] || ! type task &> /dev/null; then
  bash "$INSTALL_TASK_SCRIPT"
  SHELL_PROFILE_PATH="$(cat "$TMP_PROFILE_PATH")"
  if [ -n "$SHELL_PROFILE_PATH" ]; then
    # shellcheck disable=SC1090
    . "$SHELL_PROFILE_PATH"
  fi
fi

# @description Ensure profile is sourced (in case of error with SHELL_PROFILE_PATH)
case "${SHELL}" in
  */bash*)
    if [[ -r "${HOME}/.bash_profile" ]]; then
      . "${HOME}/.bash_profile"
    else
      . "${HOME}/.profile"
    fi
    ;;
  */zsh*)
    . "${HOME}/.zshrc"
    ;;
  *)
    . "${HOME}/.profile"
    ;;
esac

# @description Ensure Taskfile.yml is valid
cd "$PROJECT_BASE_DIR" || exit
bash "$VALID_TASKFILE_SCRIPT"

# @description Run the start logic, if appropriate
if [ -z "$GITLAB_CI" ]; then
  task start
  if [ -f .config/log ] && [ -n "$SHELL_PROFILE_PATH" ]; then
    .config/log info 'There may have been changes to your PATH variable. You may have to run:\n'
    .config/log info '`. '"$SHELL_PROFILE_PATH"'`'
  fi
fi
