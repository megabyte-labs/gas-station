#!/bin/bash
# Directory where files for import are located (need to point to root directory of ansible role)
import_files="/home/hawkwood/Playbooks/misc/common"
# Directory where gitlab repository is located (need to point to directory where roles directory is)
git_repository_dir="/home/hawkwood/Playbooks"

if [[ -z "$import_files" || -z "$git_repository_dir" ]]; then
	echo "You have not filled variables!"
fi

if [[ -d "$git_repository_dir/roles" ]]; then
	# added "not path" part to avoid copying files into .git directory and other hidden directories
	find "$git_repository_dir" -mindepth 3 -maxdepth 3 -type d -not -path '*/\.*' | while read gitrepo
	do
		ls -A "$import_files" | while read skriven
                do
                        cp -Rf "$import_files/$skriven" "$gitrepo"
                done
	done
else
	echo "Roles directory do not exist in git directory. Did you set right directory path?"
fi
