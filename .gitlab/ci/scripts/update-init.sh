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
  git fetch --all
  git checkout master
fi

# @description Clone shared files repository
rm -rf common-shared
git clone --depth=1 https://gitlab.com/megabyte-labs/common/shared.git common-shared

# @description Refresh taskfiles and GitLab CI files
mkdir -p .config
rm -rf .config/taskfiles
if [[ "$OSTYPE" == 'darwin'* ]]; then
  cp -rf common-shared/common/.config/taskfiles .config
  cp -rf common-shared/common/.config/scripts .config
else
  cp -rT common-shared/common/.config/taskfiles .config/taskfiles
  cp -rT common-shared/common/.config/scripts .config/scripts
fi
mkdir -p .gitlab
rm -rf .gitlab/ci
if [[ "$OSTYPE" == 'darwin'* ]]; then
  cp -rf common-shared/common/.gitlab/ci .gitlab
else
  cp -rT common-shared/common/.gitlab/ci .gitlab/ci
fi

cp common-shared/common/.config/log .config/log

# @description Ensure proper NPM dependencies are installed
echo "Installing NPM packages"
if [ ! -f 'package.json' ]; then
  echo "{}" > package.json
fi
if [ -f 'package-lock.json' ]; then
  rm package-lock.json
fi

# @description Remove old packages
TMP="$(mktemp)" && sed 's/.*cz-conventional-changelog.*//' < package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && sed 's/.*config-conventional.*//' < package.json > "$TMP" && mv "$TMP" package.json
rm -f temp.json
TMP="$(mktemp)" && jq 'del(.devDependencies["@mblabs/prettier-config"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["@commitlint/config-conventional"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["@mblabs/eslint-config"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["@mblabs/release-config"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["@typescript-eslint/eslint-plugin"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["commitlint-config-gitmoji"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["cz-conventional-changelog"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["glob"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["handlebars-helpers"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.devDependencies["semantic-release"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.optionalDependencies["chalk"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.optionalDependencies["inquirer"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.optionalDependencies["signale"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.optionalDependencies["string-break"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq 'del(.dependencies["tslib"])' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq '.private = false' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq '.devDependencies["@washingtondc/development"] = "^1.0.2"' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq '.devDependencies["@washingtondc/prettier"] = "^1.0.0"' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq '.devDependencies["@washingtondc/release"] = "^0.0.2"' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq '.devDependencies["eslint-config-strict-mode"] = "^1.0.0"' package.json > "$TMP" && mv "$TMP" package.json
TMP="$(mktemp)" && jq '.devDependencies["sleekfast"] = "^0.0.1"' package.json > "$TMP" && mv "$TMP" package.json

if [ "$(jq -r '.blueprint.group' package.json)" == 'documentation' ]; then
  TMP="$(mktemp)" && jq '.eslintConfig.rules["import/no-extraneous-dependencies"] = "off"' package.json > "$TMP" && mv "$TMP" package.json
fi

if [ -f meta/main.yml ]; then
  yq eval -i '.galaxy_info.min_ansible_version = 2.10' meta/main.yml
fi

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
rm -f CODE_OF_CONDUCT.md
rm -f CONTRIBUTING.md
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
rm -f molecule/default/converge.yml
rm -f molecule/default/prepare.yml
rm -f molecule/docker/converge.yml
rm -f molecule/docker/prepare.yml
rm -f .github/workflows/macOS.yml
rm -f .config/docs/CODE_OF_CONDUCT.md
rm -f .config/docs/CONTRIBUTING.md
if test -d .config/docs; then
  cd .config/docs || exit
  rm -rf .git .config .github .gitlab .vscode .editorconfig .gitignore .gitlab-ci.yml
  rm -rf LICENSE Taskfile.yml package-lock.json package.json poetry.lock pyproject.toml
  cd ../..
fi

# @description Ensure pnpm field is populated
if type yq &> /dev/null && [ "$(yq e '.vars.NPM_PROGRAM_LOCAL' Taskfile.yml)" != 'pnpm' ]; then
  yq e -i '.vars.NPM_PROGRAM_LOCAL = "pnpm"' Taskfile.yml
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
  git add --all
else
  task prepare
  task start
fi
