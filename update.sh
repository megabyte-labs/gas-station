#!/bin/bash

# This script performs maintenance on this repository. It ensures git submodules are
# installed and then copies over base files from the modules. It also generates the
# documentation.

set -e

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
cp ./modules/shared/.cspell.json .cspell.json
cp ./modules/shared/.editorconfig .editorconfig
cp ./modules/shared/.flake8 .flake8
cp ./modules/shared/.mdlrc .mdlrc
cp ./modules/shared/.prettierrc .prettierrc
cp ./modules/shared/.yamllint .yamllint
cp ./modules/shared/CODE_OF_CONDUCT.md CODE_OF_CONDUCT.md
cp -rf ./modules/ansible/.gitlab .
cp -rf ./modules/ansible/.vscode .
cp ./modules/ansible/.ansible-lint .ansible-lint
cp ./modules/ansible/.gitignore .gitignore
cp ./modules/ansible/.pre-commit-config.yaml .pre-commit-config.yaml
cp ./modules/ansible/requirements.txt requirements.txt
mkdir -p molecule/archlinux-desktop
mkdir -p molecule/default
mkdir -p molecule/docker
mkdir -p molecule/ubuntu-desktop
cp ./modules/ansible/molecule/archlinux-desktop/molecule.yml ./molecule/archlinux-desktop/molecule.yml
cp ./modules/ansible/molecule/default/molecule.yml ./molecule/default/molecule.yml
cp ./modules/ansible/molecule/docker/molecule.yml ./molecule/docker/molecule.yml
cp ./modules/ansible/molecule/ubuntu-desktop/molecule.yml ./molecule/ubuntu-desktop/molecule.yml
jq -s '.[0] * .[1]' blueprint.json ./modules/docs/common.json > __bp.json
npx @appnest/readme generate --config __bp.json --input ./modules/docs/blueprint-contributing.md --output CONTRIBUTING.md
npx @appnest/readme generate --config __bp.json --input ./modules/docs/blueprint-readme-playbooks.md
rm __bp.json
