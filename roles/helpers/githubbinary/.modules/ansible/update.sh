#!/bin/bash

# This script performs maintenance on this repository. It ensures git submodules are
# installed and then copies over base files from the modules. It also generates the
# documentation.

set -ex

# Ensure submodules are up to date
if [ ! -d "./.modules/docs" ]; then
  git submodule add -b master https://gitlab.com/megabyte-space/documentation/ansible.git ./.modules/docs
else
  cd ./.modules/docs
  git checkout master && git pull origin master
  cd ../..
fi
if [ ! -d "./.modules/shared" ]; then
  git submodule add -b master https://gitlab.com/megabyte-space/common/shared.git ./.modules/shared
else
  cd ./.modules/shared
  git checkout master && git pull origin master
  cd ../..
fi

# Copy over files from the shared submodule
cp -Rf ./.modules/shared/.github .
cp -Rf ./.modules/shared/.gitlab .
cp -Rf ./.modules/shared/.vscode .
cp ./.modules/shared/.editorconfig .editorconfig
cp ./.modules/shared/.flake8 .flake8
cp ./.modules/shared/.prettierignore .prettierignore
cp ./.modules/shared/.yamllint .yamllint
cp ./.modules/shared/CODE_OF_CONDUCT.md CODE_OF_CONDUCT.md

# Check for presence of the main.yml folder
if [ ! -f ./main.yml ]; then
  # main.yml is not present so this must be a role folder

  # Replace the role_name placeholder with the repository folder name
  ROLE_FOLDER=$(basename "$PWD")
  if [[ "$OSTYPE" == "darwin"* ]]; then
    grep -rl 'MEGABYTE_ROLE_PLACEHOLDER' ./.modules/ansible/files | xargs sed -i .bak "s/MEGABYTE_ROLE_PLACEHOLDER/${ROLE_FOLDER}/g"
    find ./.modules/ansible/files -name "*.bak" -type f -delete
  else
    grep -rl 'MEGABYTE_ROLE_PLACEHOLDER' ./.modules/ansible/files | xargs sed -i "s/MEGABYTE_ROLE_PLACEHOLDER/${ROLE_FOLDER}/g"
  fi
  
  # Copy files over from the Ansible shared submodule
  if [ -f ./package.json ]; then
    # Retain package.json "name", "description", and "version"
    PACKAGE_DESCRIPTION=$(cat package.json | jq '.description')
    PACKAGE_NAME=$(cat package.json | jq '.name' | cut -d '"' -f 2)
    PACKAGE_VERSION=$(cat package.json | jq '.version' | cut -d '"' -f 2)
    cp -Rf ./.modules/ansible/files/ .
    jq --arg a ${PACKAGE_DESCRIPTION//\/} '.description = $a' package.json > __jq.json && mv __jq.json package.json
    jq --arg a ${PACKAGE_NAME//\/} '.name = $a' package.json > __jq.json && mv __jq.json package.json
    jq --arg a ${PACKAGE_VERSION//\/} '.version = $a' package.json > __jq.json && mv __jq.json package.json
    npx prettier-package-json --write
  else
    cp -Rf ./.modules/ansible/files/ .
  fi
  

  # Reset the Ansible shared module to HEAD
  cd ./.modules/ansible
  git reset --hard HEAD
  cd ../..
else
  # Since this is not a role folder, it must be the main playbook

  # Selectively copy parts of the ansible submodule
  cp -Rf ./.modules/ansible/files/.gitlab .
  cp -Rf ./.modules/ansible/files/.husky .
  cp -Rf ./.modules/ansible/files/.vscode .
  cp -Rf ./.modules/ansible/files/molecule .
  cp ./.modules/ansible/files/LICENSE LICENSE
  if [ -f ./package.json ]; then
    # Retain package.json "name", "description", and "version"
    PACKAGE_DESCRIPTION=$(cat package.json | jq '.description')
    PACKAGE_NAME=$(cat package.json | jq '.name' | cut -d '"' -f 2)
    PACKAGE_VERSION=$(cat package.json | jq '.version' | cut -d '"' -f 2)
    cp ./.modules/ansible/files/package.json package.json
    jq --arg a ${PACKAGE_DESCRIPTION//\/} '.description = $a' package.json > __jq.json && mv __jq.json package.json
    jq --arg a ${PACKAGE_NAME//\/} '.name = $a' package.json > __jq.json && mv __jq.json package.json
    jq --arg a ${PACKAGE_VERSION//\/} '.version = $a' package.json > __jq.json && mv __jq.json package.json
    npx prettier-package-json --write
  else
    cp ./.modules/ansible/files/package.json package.json
  fi
  cp ./.modules/ansible/files/requirements.txt requirements.txt
fi

# Ensure the pre-commit hook is executable
chmod 755 .husky/pre-commit

# Generate the documentation
README_TEMPLATE=readme
if [ -f ./main.yml ]; then
  # main.yml is in directory so this must be the root playbook directory
  README_TEMPLATE=readme-playbooks
fi
jq -s '.[0] * .[1]' .blueprint.json ./.modules/docs/common.json > __bp.json | true
npx -y @appnest/readme generate --config __bp.json --input ./.modules/docs/blueprint-contributing.md --output CONTRIBUTING.md | true
npx -y @appnest/readme generate --config __bp.json --input ./.modules/docs/blueprint-$README_TEMPLATE.md | true
rm __bp.json

# Install Python 3 requirements if requirements.txt is present
if [ -f requirements.txt ]; then
  pip3 install -r requirements.txt
fi

# Install Ansible Galaxy requirements if requirements.yml is present
if [ -f requirements.yml ]; then
  ansible-galaxy install -r requirements.yml
fi

echo "*** Done updating meta files and generating documentation ***"
