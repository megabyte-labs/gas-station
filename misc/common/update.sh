#!/bin/bash

# This script performs maintenance on this repository. It ensures git submodules are
# installed and then copies over base files from the modules.

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
cp ./modules/shared/.editorconfig .editorconfig
cp ./modules/shared/.flake8 .flake8
cp -rf ./modules/shared/.github .
cp ./modules/shared/.gitignore .gitignore
cp -rf ./modules/shared/.gitlab .
cp ./modules/shared/.mdlrc .mdlrc
cp ./modules/shared/.prettierrc .prettierrc
cp -rf ./modules/shared/.vscode .
cp ./modules/shared/.yamllint .yamllint
cp ./modules/shared/CODE_OF_CONDUCT.md CODE_OF_CONDUCT.md
ROLE_FOLDER=$(basename "$PWD")
if [[ "$OSTYPE" == "darwin"* ]]; then
  grep -rl 'MEGABYTE_ROLE_PLACEHOLDER' ./modules/ansible | xargs sed -i .bak "s/MEGABYTE_ROLE_PLACEHOLDER/${ROLE_FOLDER}/g"
  find ./modules/ansible -name "*.bak" -type f -delete
else
  grep -rl 'MEGABYTE_ROLE_PLACEHOLDER' ./modules/ansible | xargs sed -i "s/MEGABYTE_ROLE_PLACEHOLDER/${ROLE_FOLDER}/g"
fi
cp -rf ./modules/ansible/* .
cd modules/ansible
git reset --hard HEAD
cd ../..
mv gitlab-ci.yml .gitlab-ci.yml
cp ./modules/docs/blueprint-contributing.md blueprint.md
npx @appnest/readme generate --extend ./modules/docs/common.json
mv README.md CONTRIBUTING.md
cp ./modules/docs/blueprint-readme.md blueprint.md
npx @appnest/readme generate --extend ./modules/docs/common.json
rm blueprint.md
