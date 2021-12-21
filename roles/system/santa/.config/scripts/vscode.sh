#!/usr/bin/env bash

# @file .config/scripts/vscode.sh
# @brief Includes initialization logic that may be necessary for first time users of VSCode tasks

set -eo pipefail

# @description Detect script paths
BASH_SRC="$(dirname "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(cd "$BASH_SRC"; pwd -P)"
TASK_SCRIPT_PATH="$SOURCE_PATH/lib/task.sh"

# @description Ensure Task is installed
bash "$TASK_SCRIPT_PATH"
