#!/bin/bash
# Directory where files for import are located (need to point to root directory of ansible role)
import_files="/Users/bzalewski/Playbooks/shared"
# Directory where gitlab repository is located (need to point to directory where roles directory is)
git_repository_dir="/Users/bzalewski/Playbooks"

if [[ -z "$import_files" || -z "$git_repository_dir" ]]; then
	echo "You have not filled variables!"
fi

if [[ -d "$git_repository_dir/roles" ]]; then
	find "$git_repository_dir" -mindepth 3 -maxdepth 3 -type d | while read gitrepo
	do
		cp -Rf "$import_files"/* "$gitrepo"
	done
else
	echo "Roles directory do not exist in git directory. Did you set right directory path?"
fi
