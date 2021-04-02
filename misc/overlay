#!/bin/bash
# Directory where files for import are located (need to point to root directory of ansible role)
import_files="/Users/bzalewski/Playbooks/misc/common"
# Directory where gitlab repository is located (need to point to directory where roles directory is)
git_repository_dir="/Users/bzalewski/Playbooks"

if [[ -z "$import_files" || -z "$git_repository_dir" ]]; then
	echo "You have not filled variables!"
fi
echo "---" >> /Users/bzalewski/Playbooks/misc/sample.txt
if [[ -d "$git_repository_dir/roles" ]]; then
	# added "not path" part to avoid copying files into .git directory and other hidden directories
	find "$git_repository_dir/roles" -mindepth 2 -maxdepth 2 -type d -not -path '*/\.*' | while read -r gitrepo
	do
		gfind "$import_files" -maxdepth 1 -mindepth 1 -printf "%f\n" | while read -r skriven
                do
                  echo "********************"
                  echo "$gitrepo"
                  echo "********************"
                  cd "$gitrepo" || exit
                  bash .update.sh
                  #cp -Rf "$import_files/$skriven" "$gitrepo"
                done
	done
else
	echo "Roles directory do not exist in git directory. Did you set right directory path?"
fi
