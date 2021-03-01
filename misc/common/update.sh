#!/bin/bash

# This script performs maintenance on this repository. It ensures git submodules are
# installed and then copies over base files from the modules.

set -e

git submodule update --init --recursive

if [ ! -d "./modules" ]; then
  mkdir modules
fi
if [ ! -d "./modules/ansible" ]; then
  cd modules
  git submodule add -b master git@gitlab.com:megabyte-space/common/ansible.git
  cd ..
else
  cd modules/ansible
  git checkout master
  git pull origin master
  cd ../..
fi
if [ ! -d "./modules/docs" ]; then
  cd modules
  git submodule add -b master git@gitlab.com:megabyte-space/documentation/ansible.git docs
  cd ..
else
  cd modules/docs
  git checkout master
  git pull origin master
  cd ../..
fi
if [ ! -d "./modules/shared" ]; then
  cd modules
  git submodule add -b master git@gitlab.com:megabyte-space/common/shared.git
  cd ..
else
  cd modules/shared
  git checkout master
  git pull origin master
  cd ../..
fi
cp -rf ./modules/shared/.github .
cp -rf ./modules/shared/.gitlab .
cp -rf ./modules/shared/.vscode .
cp ./modules/shared/.editorconfig .editorconfig
cp ./modules/shared/.flake8 .flake8
cp ./modules/shared/.mdlrc .mdlrc
cp ./modules/shared/.prettierrc .prettierrc
cp ./modules/shared/.yamllint .yamllint
cp ./modules/shared/CODE_OF_CONDUCT.md CODE_OF_CONDUCT.md
ROLE_FOLDER=$(basename "$PWD")
if [[ "$OSTYPE" == "darwin"* ]]; then
  grep -rl 'MEGABYTE_ROLE_PLACEHOLDER' ./modules/ansible | xargs sed -i .bak "s/MEGABYTE_ROLE_PLACEHOLDER/${ROLE_FOLDER}/g"
  find ./modules/ansible -name "*.bak" -type f -delete
else
  grep -rl 'MEGABYTE_ROLE_PLACEHOLDER' ./modules/ansible | xargs sed -i "s/MEGABYTE_ROLE_PLACEHOLDER/${ROLE_FOLDER}/g"
fi
rsync -avr --exclude='./modules/ansible/.git' --exclude '*.git' ./modules/ansible/ .
cd modules/ansible
git reset --hard HEAD
cd ../..
mv gitlab-ci.yml .gitlab-ci.yml
jq -s '.[0] * .[1]' blueprint.json ./modules/docs/common.json > __bp.json || true
npx @appnest/readme generate --config __bp.json --input ./modules/docs/blueprint-contributing.md --output CONTRIBUTING.md || true
npx @appnest/readme generate --config __bp.json --input ./modules/docs/blueprint-readme.md || true
rm __bp.json
