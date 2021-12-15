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

# @description Detect script paths
BASH_SRC="$(dirname "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(cd "$BASH_SRC"; pwd -P)"
PROJECT_BASE_DIR="$SOURCE_PATH/../.."
INSTALL_PACKAGE_SCRIPT="$SOURCE_PATH/lib/package.sh"
INSTALL_TASK_SCRIPT="$SOURCE_PATH/lib/task.sh"
VALID_TASKFILE_SCRIPT="$SOURCE_PATH/lib/taskfile.sh"

# @description Ensure basic dependencies are installed
bash "$INSTALL_PACKAGE_SCRIPT" "curl"
bash "$INSTALL_PACKAGE_SCRIPT" "git"

# @description Attempts to pull the latest changes if the folder is a git repository
cd "$PROJECT_BASE_DIR" || exit
if [ -d .git ] && type git &> /dev/null; then
  git pull origin master --ff-only
  git submodule update --init --recursive
fi

# @description Ensures Task is installed and properly configured and then runs the `start` task
if [ "$GITLAB_CI" != 'true' ] || ! type task &> /dev/null; then
  bash "$INSTALL_TASK_SCRIPT"
fi
bash "$VALID_TASKFILE_SCRIPT"
cd "$PROJECT_BASE_DIR" || exit
if [ -z "$GITLAB_CI" ]; then task start; fi
