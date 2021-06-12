#!/bin/bash

# This script performs maintenance on this repository. It ensures git submodules are
# installed and then copies over base files from the modules. It also generates the
# documentation.

set -e

# shellcheck disable=SC2154
if [ "$container" != 'docker' ]; then
  curl -sL https://git.io/_has | bash -s docker git jq node npm python3 wget
fi

export REPO_TYPE=ansible
git submodule update --init --recursive
if [ ! -d "./.modules/${REPO_TYPE}" ]; then
  mkdir -p ./.modules
  git submodule add -b master https://gitlab.com/megabyte-space/common/$REPO_TYPE.git ./.modules/$REPO_TYPE
else
  cd ./.modules/$REPO_TYPE
  git checkout master && git pull origin master --ff-only
  cd ../..
fi
bash ./.modules/$REPO_TYPE/update.sh
