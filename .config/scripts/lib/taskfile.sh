#!/usr/bin/env bash

# @file .config/scripts/lib/update.sh
# @brief Ensures repository is prepped for running the Taskfile start command

set -eo pipefail

# @description Ensures a valid Taskfile.yml file is being used and that the taskfile
# sources are up-to-date.
#
# @example
#   ensureValidTaskfile
#
# @exitcode 0 If the Taskfile.yml and taskfiles are valid and up-to-date
# @exitcode 1+ If an error was encountered
function ensureValidTaskfile() {
  if task donothing &> /dev/null; then
    echo "The Taskfile.yml and taskfile references appear to be valid"
  else
    echo "Taskfile.yml is invalid.. Attempting to non-destructively fix Taskfile.yml and taskfile references"
    git clone --depth=1 https://gitlab.com/megabyte-labs/common/shared.git .shared-common
    cp .shared-common/Taskfile.yml Taskfile.yml
    cp -rT .shared-common/common/.config/taskfiles .config/taskfiles
    rm -rf .shared-common
  fi
}

ensureValidTaskfile
