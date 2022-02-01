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

# @description Proxy function for handling logs in this script
#
# @example
#   logger warn "Warning message"
#
# @arg $1 string The type of log message (can be info, warn, success, or error)
# @arg $2 string The message to log
function logger() {
  if [ -f .config/log ]; then
    .config/log "$1" "$2"
  else
    if [ "$1" == 'error' ]; then
      echo "ERROR:   ""$2"
    elif [ "$1" == 'info' ]; then
      echo "INFO:    ""$2"
    elif [ "$1" == 'success' ]; then
      echo "SUCCESS: ""$2"
    elif [ "$1" == 'warn' ]; then
      echo "WARNING: ""$2"
    else
      echo "$2"
    fi
  fi
}

# @description Installs package when user is root on Linux
#
# @example
#   ensureRootPackageInstalled "sudo"
#
# @arg $1 string The name of the package that must be present
#
# @exitcode 0 The package was successfully installed
# @exitcode 1+ If there was an error, the package needs to be installed manually, or if the OS is unsupported
function ensureRootPackageInstalled() {
  if ! type "$1" &> /dev/null; then
    if [[ "$OSTYPE" == 'linux'* ]]; then
      if [ -f "/etc/redhat-release" ]; then
        yum update
        yum install -y "$1"
      elif [ -f "/etc/lsb-release" ]; then
        apt update
        apt install -y "$1"
      elif [ -f "/etc/arch-release" ]; then
        pacman update
        pacman -S "$1"
      elif [ -f "/etc/alpine-release" ]; then
        apk update
        apk add -y "$1"
      fi
    fi
  fi
}

# @description If the user is running this script as root, then create a new user named
# megabyte and restart the script with that user. This is required because Homebrew
# can only be invoked by non-root users.
if [ "$EUID" -eq 0 ] && [ -z "$INIT_CWD" ] && type useradd &> /dev/null; then
  # shellcheck disable=SC2016
  logger info 'Running as root - creating seperate user named `megabyte` to run script with'
  echo "megabyte ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  useradd -m -s "$(which bash)" -c "Megabyte Labs Homebrew Account" megabyte
  ensureRootPackageInstalled "sudo"
  # shellcheck disable=SC2016
  logger info 'Reloading the script with the `megabyte` user'
  exec su megabyte "$0" -- "$@"
fi

# @description Detect script paths
BASH_SRC="$(dirname "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(
  cd "$BASH_SRC"
  pwd -P
)"
PROJECT_BASE_DIR="$SOURCE_PATH/../.."

# @description Ensures ~/.local/bin is in the PATH variable on *nix machines and
# exits with an error on unsupported OS types
#
# @example
#   ensureLocalPath
#
# @set PATH string The updated PATH with a reference to ~/.local/bin
#
# @noarg
#
# @exitcode 0 If the PATH was appropriately updated or did not need updating
# @exitcode 1+ If the OS is unsupported
function ensureLocalPath() {
  if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux'* ]]; then
    # shellcheck disable=SC2016
    PATH_STRING='PATH="$HOME/.local/bin:$PATH"'
    mkdir -p "$HOME/.local/bin"
    if grep -L "$PATH_STRING" "$HOME/.profile" > /dev/null; then
      echo -e "${PATH_STRING}\n" >> "$HOME/.profile"
      logger info "Updated the PATH variable to include ~/.local/bin in $HOME/.profile"
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    logger error "FreeBSD support not added yet" && exit 1
  else
    logger warn "System type not recognized"
  fi
}

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
        sudo yum update
        sudo yum install -y "$1"
      elif [ -f "/etc/lsb-release" ]; then
        sudo apt update
        sudo apt install -y "$1"
      elif [ -f "/etc/arch-release" ]; then
        sudo pacman update
        sudo pacman -S "$1"
      elif [ -f "/etc/alpine-release" ]; then
        apk update
        apk add -y "$1"
      else
        logger error "$1 is missing. Please install $1 to continue." && exit 1
      fi
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      logger error "FreeBSD support not added yet" && exit 1
    else
      logger error "System type not recognized"
    fi
  fi
}

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
  # @description Release API URL used to get the latest release's version
  TASK_RELEASE_API="https://api.github.com/repos/go-task/task/releases/latest"
  if ! type task &> /dev/null; then
    if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl' ]]; then
      installTask
    elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
      logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
    elif [[ "$OSTYPE" == 'freebsd'* ]]; then
      logger error "FreeBSD support not added yet" && exit 1
    else
      logger error "System type not recognized. You must install task manually." && exit 1
    fi
  else
    logger info "Checking for latest version of Task"
    CURRENT_VERSION="$(task --version | cut -d' ' -f3 | cut -c 2-)"
    LATEST_VERSION="$(curl -s "$TASK_RELEASE_API" | grep tag_name | cut -c 17- | sed 's/\",//')"
    if printf '%s\n%s\n' "$LATEST_VERSION" "$CURRENT_VERSION" | sort -V -c &> /dev/null; then
      logger info "Task is already up-to-date"
    else
      logger info "A new version of Task is available (version $LATEST_VERSION)"
      logger info "The current version of Task installed is $CURRENT_VERSION"
      if ! type task &> /dev/null; then
        installTask
      else
        if rm "$(which task)" &> /dev/null; then
          installTask
        elif sudo rm "$(which task)" &> /dev/null; then
          installTask
        else
          logger warn "Unable to remove previous version of Task"
        fi
      fi
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
  # @description Release URL to use when downloading [Task](https://github.com/go-task/task)
  TASK_RELEASE_URL="https://github.com/go-task/task/releases/latest"
  CHECKSUM_DESTINATION=/tmp/megabytelabs/task_checksums.txt
  CHECKSUMS_URL="$TASK_RELEASE_URL/download/task_checksums.txt"
  DOWNLOAD_DESTINATION=/tmp/megabytelabs/task.tar.gz
  TMP_DIR=/tmp/megabytelabs
  if [[ "$OSTYPE" == 'darwin'* ]]; then
    DOWNLOAD_URL="$TASK_RELEASE_URL/download/task_darwin_amd64.tar.gz"
  else
    DOWNLOAD_URL="$TASK_RELEASE_URL/download/task_linux_amd64.tar.gz"
  fi
  mkdir -p "$(dirname "$DOWNLOAD_DESTINATION")"
  logger info "Downloading latest version of Task"
  curl -sSL "$DOWNLOAD_URL" -o "$DOWNLOAD_DESTINATION"
  curl -sSL "$CHECKSUMS_URL" -o "$CHECKSUM_DESTINATION"
  DOWNLOAD_BASENAME="$(basename "$DOWNLOAD_URL")"
  DOWNLOAD_SHA256="$(grep "$DOWNLOAD_BASENAME" < "$CHECKSUM_DESTINATION" | cut -d ' ' -f 1)"
  sha256 "$DOWNLOAD_DESTINATION" "$DOWNLOAD_SHA256" > /dev/null
  logger success "Validated checksum"
  mkdir -p "$TMP_DIR/task"
  tar -xzvf "$DOWNLOAD_DESTINATION" -C "$TMP_DIR/task" > /dev/null
  if type task &> /dev/null && [ -w "$(which task)" ]; then
    TARGET_DEST="$(which task)"
  else
    if [ -w /usr/local/bin ]; then
      TARGET_BIN_DIR='/usr/local/bin'
    else
      TARGET_BIN_DIR="$HOME/.local/bin"
    fi
    TARGET_DEST="$TARGET_BIN_DIR/task"
    mkdir -p "$TARGET_BIN_DIR"
  fi
  mv "$TMP_DIR/task/task" "$TARGET_DEST"
  logger success "Installed Task to $TARGET_DEST"
  rm "$CHECKSUM_DESTINATION"
  rm "$DOWNLOAD_DESTINATION"
}

# @description Verifies the SHA256 checksum of a file
#
# @example
#   sha256 myfile.tar.gz 5b30f9c042553141791ec753d2f96786c60a4968fd809f75bb0e8db6c6b4529b
#
# @arg $1 string Path to the file
# @arg $2 string The SHA256 signature
#
# @exitcode 0 The checksum is valid or the system is unrecognized
# @exitcode 1+ The OS is unsupported or if the checksum is invalid
function sha256() {
  if [[ "$OSTYPE" == 'darwin'* ]]; then
    if type brew &> /dev/null && ! type sha256sum &> /dev/null; then
      brew install coreutils
    else
      logger warn "Brew is not installed - this may cause issues"
    fi
    if type brew &> /dev/null; then
      PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    fi
    if type sha256sum &> /dev/null; then
      echo "$2 $1" | sha256sum -c
    else
      logger warn "Checksum validation is being skipped for $1 because the sha256sum program is not available"
    fi
  elif [[ "$OSTYPE" == 'linux-gnu'* ]]; then
    if ! type shasum &> /dev/null; then
      logger warn "Checksum validation is being skipped for $1 because the shasum program is not installed"
    else
      echo "$2  $1" | shasum -s -a 256 -c
    fi
  elif [[ "$OSTYPE" == 'linux-musl' ]]; then
    if ! type sha256sum &> /dev/null; then
      logger warn "Checksum validation is being skipped for $1 because the sha256sum program is not available"
    else
      echo "$2  $1" | sha256sum -c
    fi
  elif [[ "$OSTYPE" == 'cygwin' ]] || [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'win32' ]]; then
    logger error "Windows is not directly supported. Use WSL or Docker." && exit 1
  elif [[ "$OSTYPE" == 'freebsd'* ]]; then
    logger error "FreeBSD support not added yet" && exit 1
  else
    logger warn "System type not recognized. Skipping checksum validation."
  fi
}

##### Main Logic #####

if [ ! -f "$HOME/.profile" ]; then
  touch "$HOME/.profile"
fi

# @description Ensures ~/.local/bin is in PATH
ensureLocalPath

# @description Ensures base dependencies are installed
if [[ "$OSTYPE" == 'darwin'* ]]; then
  if ! type curl &> /dev/null && type brew &> /dev/null; then
    brew install curl
  else
    logger error "Neither curl nor brew are installed. Install one of them manually and try again."
  fi
  if ! type git &> /dev/null; then
    # shellcheck disable=SC2016
    logger info 'Git is not present. A password may be required to run `sudo xcode-select --install`'
    sudo xcode-select --install
  fi
elif [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl'* ]]; then
  if ! type curl &> /dev/null || ! type git &> /dev/null; then
    ensurePackageInstalled "curl"
    ensurePackageInstalled "git"
  fi
fi

# @description Ensures Homebrew, Poetry, jq, and yq are installed
if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl'* ]]; then
  if [ -z "$INIT_CWD" ]; then
    if ! type brew &> /dev/null; then
      logger warn "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if [ -f "$HOME/.profile" ]; then
      # shellcheck disable=SC1091
      . "$HOME/.profile"
    fi
    if ! type poetry &> /dev/null; then
      brew install poetry
    fi
    if ! type jq &> /dev/null; then
      brew install jq
    fi
    if ! type yq &> /dev/null; then
      brew install yq
    fi
  fi
fi

# @description Attempts to pull the latest changes if the folder is a git repository
cd "$PROJECT_BASE_DIR" || exit
if [ -d .git ] && type git &> /dev/null; then
  HTTPS_VERSION="$(git remote get-url origin | sed 's/git@gitlab.com:/https:\/\/gitlab.com\//')"
  git pull "$HTTPS_VERSION" master --ff-only
  git submodule update --init --recursive
fi

# @description Ensures Task is installed and properly configured
ensureTaskInstalled

# @description Run the start logic, if appropriate
cd "$PROJECT_BASE_DIR" || exit
if [ -z "$GITLAB_CI" ] && [ -z "$INIT_CWD" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.profile"
  task start
  # shellcheck disable=SC2028
  logger info 'There may have been changes to your PATH variable. You may have to reload your terminal or run:\n\n`. "$HOME/.profile"`'
fi
