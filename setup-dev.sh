#!/bin/bash
rm -rf group_vars
rm -rf host_vars
rm -rf inventories
ln -s ./environments/dev/group_vars group_vars
ln -s ./environments/dev/host_vars host_vars
ln -s ./environments/dev/inventories inventories
echo "***LOCAL E2E TEST***"
echo "1. If you are running this with a local connection then you must change the admin username/password in host_vars/workstation/vault.yml"
echo "2. You can then run the playbook locally by running 'ansible-playbook -i inventories/local.yml main.yml'"
echo "***VAGRANT E2E TEST***"
echo "Coming soon..."
echo "Prepare by setting up Vagrant and VirtualBox on your system"
