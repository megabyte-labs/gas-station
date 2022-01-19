#!/usr/bin/env bash

# @file .config/scripts/lib/task.sh
# @brief Ensures Task is installed and up-to-date
# @description
#   This script ensures that the latest version of [Task](https://github.com/go-task/task)
#   is installed. If an outdated version of Task is installed, the script will attempt
#   to overwrite the currently installed `task` binary and exit with an error if the
#   binary is not writable by the current user.

set -eo pipefail

# @description Release API URL used to get the latest release's version
TASK_RELEASE_API="https://api.github.com/repos/go-task/task/releases/latest"
# @description Release URL to use when downloading [Task](https://github.com/go-task/task)
TASK_RELEASE_URL="https://github.com/go-task/task/releases/latest"

# @description Ensures the latest version of Task is installed to `/usr/local/bin` (or `~/.local/bin`, as
# a fallback.
#
# @example
#   ensureTaskInstalled
#
# @noarg
#
# @exitcode 0 If the package is already present and up-to-date or if it was installed/updated
# @exitcode 1+ If the OS is unsupported or if there was an error either installing the package or setting the PATH
function ensureTaskInstalled() {
  if ! type task &> /dev/null; then
    if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]]; then
      installTask
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      .config/log error "Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      .config/log error "FreeBSD support not added yet" && exit 1
    else
      .config/log error "System type not recognized"
    fi
  else
    CURRENT_VERSION="$(task --version | cut -d' ' -f3 | cut -c 2-)"
    LATEST_VERSION="$(curl -s "$TASK_RELEASE_API" | grep tag_name | cut -c 17- | sed 's/\",//')"
    if printf '%s\n%s\n' "$LATEST_VERSION" "$CURRENT_VERSION" | sort --check=quiet --version-sort; then
      .config/log info "Task is already up-to-date"
    else
      .config/log info "A new version of Task is available (version $LATEST_VERSION)"
      if [ ! -w "$(which task)" ]; then
        local MSG_A
        MSG_A="ERROR: Task is currently installed in a location the current user does not have write permissions for."
        local MSG_B
        MSG_B="Manually remove Task from its current location ($(which task)) and then run this script again."
        .config/log error """$MSG_A"" ""$MSG_B""" && exit 1
      fi
      installTask
    fi
  fi
}

# @description Helper function for ensureTaskInstalled that performs the installation of Task.
#
# @see ensureTaskInstalled
#
# @example
#   installTask
#
# @noarg
#
# @exitcode 0 If Task installs/updates properly
# @exitcode 1+ If the installation fails
function installTask() {
  local CHECKSUM_DESTINATION=/tmp/megabytelabs/task_checksums.txt
  local CHECKSUMS_URL="$TASK_RELEASE_URL/download/task_checksums.txt"
  local DOWNLOAD_DESTINATION=/tmp/megabytelabs/task.tar.gz
  local TMP_DIR=/tmp/megabytelabs
  if [[ "$OSTYPE" == 'darwin'* ]]; then
    local DOWNLOAD_URL="$TASK_RELEASE_URL/download/task_darwin_amd64.tar.gz"
  else
    local DOWNLOAD_URL="$TASK_RELEASE_URL/download/task_linux_amd64.tar.gz"
  fi
  mkdir -p "$(dirname "$DOWNLOAD_DESTINATION")"
  .config/log info 'Downloading latest version of Task'
  curl -sSL "$DOWNLOAD_URL" -o "$DOWNLOAD_DESTINATION"
  curl -sSL "$CHECKSUMS_URL" -o "$CHECKSUM_DESTINATION"
  local DOWNLOAD_BASENAME
  DOWNLOAD_BASENAME="$(basename "$DOWNLOAD_URL")"
  local DOWNLOAD_SHA256
  DOWNLOAD_SHA256="$(grep "$DOWNLOAD_BASENAME" < "$CHECKSUM_DESTINATION" | cut -d ' ' -f 1)"
  sha256 "$DOWNLOAD_DESTINATION" "$DOWNLOAD_SHA256"
  .config/log success 'Validated checksum'
  mkdir -p "$TMP_DIR/task"
  tar -xzvf "$DOWNLOAD_DESTINATION" -C "$TMP_DIR/task"
  if type task &> /dev/null && [ -w "$(which task)" ]; then
    local TARGET_DEST
    TARGET_DEST="$(which task)"
  else
    if [ -w /usr/local/bin ]; then
      local TARGET_BIN_DIR='/usr/local/bin'
    else
      local TARGET_BIN_DIR="$HOME/.local/bin"
    fi
    local TARGET_DEST="$TARGET_BIN_DIR/task"
  fi
  mkdir -p "$TARGET_BIN_DIR"
  mv "$TMP_DIR/task/task" "$TARGET_BIN_DIR/"
  .config/log success "Successfully installed Task to $TARGET_DEST"
  rm "$CHECKSUM_DESTINATION"
  rm "$DOWNLOAD_DESTINATION"
}

# @description Verifies the SHA256 checksum of a file
#
# @example
#   sha256 myfile.tar.gz 5b30f9c042553141791ec753d2f96786c60a4968fd809f75bb0e8db6c6b4529b
#
# @arg $1 string The path to the file
# @arg $2 string The SHA256 signature
#
# @exitcode 0 If the checksum is valid or if a warning about the checksum software not being present is displayed
# @exitcode 1+ If the OS is unsupported or if the checksum is invalid
function sha256() {
  if [[ "$OSTYPE" == 'darwin'* ]]; then
    if ! type sha256sum &> /dev/null; then
      if type brew &> /dev/null; then
        brew install coreutils
      else
        .config/log warn "WARNING: checksum validation is being skipped for $1 because both brew and sha256sum are unavailable"
      fi
    fi
    if type sha256sum &> /dev/null; then
      echo "$2 $1" | sha256sum --check
    fi
  elif [[ "$OSTYPE" == 'linux-gnu'* ]]; then
    if ! type shasum &> /dev/null; then
      .config/log warn "WARNING: checksum validation is being skipped for $1 because the shasum program is not installed"
    else
      echo "$2  $1" | shasum -s -a 256 -c
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    .config/log error "Windows is not directly supported. Use WSL or Docker." && exit 1
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    .config/log error "FreeBSD support not added yet" && exit 1
  else
    .config/log error "System type not recognized" && exit 1
  fi
}

# @description Ensures Task is installed and properly configured
ensureTaskInstalled
