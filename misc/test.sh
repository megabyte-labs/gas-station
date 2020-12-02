#!/bin/bash

git_repository_dir="/home/hawkwood/Playbooks"

find "$git_repository_dir/roles" -mindepth 2 -maxdepth 2 -type d -not -path "*/\.*" | while read -r gitrepo
do
    cd "$gitrepo" || continue
    rm -rf common
    rm ./molecule/default/playbook.yml
    cp -rT /home/hawkwood/Playbooks/misc/common .
    CURRENT=`pwd`
    BASENAME=`basename "$CURRENT"`
    sed -i "s/{{ role_name }}/$BASENAME/" ./molecule/default/converge.yml
done
