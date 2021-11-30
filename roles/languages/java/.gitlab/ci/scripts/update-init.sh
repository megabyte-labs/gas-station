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
cp -rT common-shared/common/.config/taskfiles .config/taskfiles
cp -rT common-shared/common/.config/scripts .config/scripts
mkdir -p .gitlab
rm -rf .gitlab/ci
cp -rT common-shared/common/.gitlab/ci .gitlab/ci

# @description Ensure proper NPM dependencies are installed
echo "Installing NPM packages"
if [ ! -f 'package.json' ]; then
  echo "{}" > package.json
fi

npm install --save-dev --ignore-scripts @mblabs/eslint-config@latest @mblabs/prettier-config@latest handlebars-helpers
npm install --save-dev --ignore-scripts @commitlint/config-conventional cz-conventional-changelog
npm install --save-optional --ignore-scripts chalk inquirer signale string-break

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
rm -f .ansible-lint
rm -f .eslintrc.cjs
rm -f .flake8
rm -f .gitmodules
rm -f .prettierignore
rm -f .start.sh
rm -f .update.sh
rm -f .yamllint
rm -f requirements.txt
rm -rf .common
rm -rf .config/esbuild
rm -rf .husky
rm -rf tests
if test -d .config/docs; then
  cd .config/docs || exit
  rm -rf .git .config .github .gitlab .vscode .editorconfig .gitignore .gitlab-ci.yml
  rm -rf LICENSE Taskfile.yml package-lock.json package.json poetry.lock pyproject.toml
  cd ../..
fi

# @description Ensure pnpm field is populated
if [ "$(yq e '.vars.NPM_PROGRAM_LOCAL' Taskfile.yml)" == 'null' ]; then
  yq e -i '.vars.NPM_PROGRAM_LOCAL = npm' Taskfile.yml
fi

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
