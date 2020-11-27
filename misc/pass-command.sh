#!/bin/bash

if [[ -z "$1" || -n "$2" && "$2" != 'Yes' && "$2" != 'True' ]]; then
	echo You have to use double quotes
	echo 'Usage: ./pass-command.sh "molecule test" (True)'
	exit 1;
fi

if [[ "$2" == 'True' || "$2" == 'Yes' ]]; then
	set -e
fi

# Directory where gitlab repository is located (need to point to directory where roles directory is)
git_repository_dir="/home/hawkwood/Playbooks"

find "$git_repository_dir" -mindepth 3 -maxdepth 3 -type d -not -path '*/\.*' | while read -r gitrepo
do
	cd "$gitrepo" || continue
	$1
done
