#!/usr/bin/env bash

# @file .gitlab/ci/scripts/update-init.sh
# @brief Script that executes before the start task if the UPDATE_INIT_SCRIPT is set to the URL
# of this script

set -eo pipefail

# @description Configure git if environment is GitLab CI
if [ -n "$GITLAB_CI" ]; then
  git remote set-url origin "https://root:$GROUP_ACCESS_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git"
  git config user.email "$GITLAB_CI_EMAIL"
  git config user.name "$GITLAB_CI_NAME"
  git checkout "$CI_COMMIT_REF_NAME"
  git pull origin "$CI_COMMIT_REF_NAME"
elif git reset --hard HEAD &> /dev/null; then
  git clean -fxd
  git checkout master
  git pull origin master
fi

# @description Clone shared files repository
rm -rf common-shared
git clone --depth=1 https://gitlab.com/megabyte-labs/common/shared.git common-shared

# @description Refresh taskfiles and GitLab CI files
mkdir -p .config
rm -rf .config/taskfiles
cp -rf common-shared/common/.config/taskfiles .config/
cp -rf common-shared/common/.config/scripts .config/
mkdir -p .gitlab
rm -rf .gitlab/ci
cp -rf common-shared/common/.gitlab/ci .gitlab/

# @description Ensure proper NPM dependencies are installed
echo "Installing NPM packages"
if [ ! -f 'package.json' ]; then
  echo "{}" > package.json
fi
if [ -f 'package-lock.json' ]; then
  rm package-lock.json
fi
if type pnpm &> /dev/null; then
  pnpm install --save-dev --ignore-scripts @mblabs/eslint-config@latest @mblabs/prettier-config@latest handlebars-helpers glob
  pnpm install --save-optional --ignore-scripts chalk inquirer signale string-break
fi
sed 's/.*cz-conventional-changelog.*//' < package.json
# @description Re-generate the Taskfile.yml if it has invalid includes
echo "Ensuring Taskfile is properly configured"
task donothing || EXIT_CODE=$?
if [ -n "$EXIT_CODE" ]; then
  echo "Copying shared Taskfile.yml"
  cp common-shared/Taskfile.yml Taskfile.yml
fi

# @description Clean up
rm -rf common-shared

# @description Ensure files from old file structure are removed (temporary code)
echo "Removing files from old project structures"
rm -f .ansible-lint
rm -f .eslintrc.cjs
rm -f .flake8
rm -f .gitmodules
rm -f .prettierignore
rm -f .start.sh
rm -f .update.sh
rm -f .yamllint
rm -f requirements.txt
rm -f .config/eslintcache
rm -rf .common
rm -rf .config/esbuild
rm -rf .pnpm-store
rm -rf .husky
rm -rf tests
rm -rf molecule/archlinux-desktop
rm -rf molecule/centos-desktop
rm -rf molecule/ci-docker-archlinux
rm -rf molecule/ci-docker-centos
rm -rf molecule/ci-docker-debian-snap
rm -rf molecule/ci-docker-debian
rm -rf molecule/ci-docker-fedora
rm -rf molecule/ci-docker-ubuntu-snap
rm -rf molecule/ci-docker-ubuntu
rm -rf molecule/debian-desktop
rm -rf molecule/docker-snap
rm -rf molecule/fedora-desktop
rm -rf molecule/macos-desktop
rm -rf molecule/ubuntu-desktop
rm -rf molecule/windows-desktop
if test -d .config/docs; then
  cd .config/docs || exit
  rm -rf .git .config .github .gitlab .vscode .editorconfig .gitignore .gitlab-ci.yml
  rm -rf LICENSE Taskfile.yml package-lock.json package.json poetry.lock pyproject.toml
  cd ../..
fi

# @description Ensure pnpm field is populated
yq e -i '.vars.NPM_PROGRAM_LOCAL = "pnpm"' Taskfile.yml

# @description Ensure documentation is in appropriate location (temporary code)
mkdir -p docs
if test -f "CODE_OF_CONDUCT.md"; then
  mv CODE_OF_CONDUCT.md docs
fi
if test -f "CONTRIBUTING.md"; then
  mv CONTRIBUTING.md docs
fi
if test -f "ARCHITECTURE.md"; then
  mv ARCHITECTURE.md docs
fi

# @description Commit and push the changes
if [ -n "$GITLAB_CI" ]; then
  task ci:commit
else
  task prepare
  task start
fi
