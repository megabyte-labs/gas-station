#!/bin/bash
# Directory where files for import are located (need to point to root directory of ansible role)
import_files="/Users/bzalewski/Playbooks/misc/common"
# Directory where gitlab repository is located (need to point to directory where roles directory is)
git_repository_dir="/Users/bzalewski/Playbooks"

if [[ -z "$import_files" || -z "$git_repository_dir" ]]; then
	echo "You have not filled variables!"
fi

if [[ -d "$git_repository_dir/roles" ]]; then
	# added "not path" part to avoid copying files into .git directory and other hidden directories
	find "$git_repository_dir/roles" -mindepth 2 -maxdepth 2 -type d -not -path '*/\.*' | while read -r gitrepo
	do
    echo $import_files
		gfind "$import_files" -maxdepth 1 -mindepth 1 -printf "%f\n" | while read -r skriven
                do
                  cp -Rf "$import_files/$skriven" "$gitrepo"
                  cd "$gitrepo" || exit
                  ROLE_FOLDER=$(basename "$PWD")
                  sed -i .bak "s/CI_ROLE_NAME/${ROLE_FOLDER}/g" tests/test.yml
                  rm tests/test.yml.bak
                  sed -i .bak "s/CI_ROLE_NAME/${ROLE_FOLDER}/g" molecule/virtualbox/converge.yml
                  rm molecule/virtualbox/converge.yml.bak
                  sed -i .bak "s/CI_ROLE_NAME/${ROLE_FOLDER}/g" molecule/default/converge.yml
                  rm molecule/default/converge.yml.bak
                        #cp -Rf "$import_files/$skriven" "$gitrepo"
                done
	done
else
	echo "Roles directory do not exist in git directory. Did you set right directory path?"
fi
