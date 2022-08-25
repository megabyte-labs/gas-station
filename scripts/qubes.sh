#!/usr/bin/env bash

ANSIBLE_DVM="ansible-dvm"

set -ex

# Update dom0
sudo qubesctl --show-output state.sls update.qubes-dom0
sudo qubes-dom0-update --clean -y
sudo qubes-dom0-update -y ansible-python3 # Add if statement

# Ensure qubes-template-debian-11-minimal is installed
if [ ! -d '/var/lib/qubes/vm-templates/debian-11-minimal' ]; then
  sudo qubes-dom0-update qubes-template-debian-11-minimal
fi

# Download Gas Station and transfer to dom0 via DispVM
qvm-create --label red --template debian-11 "$ANSIBLE_DVM"
qvm-run "$ANSIBLE_DVM" 'curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/archive/master/gas-station-master.tar.gz > Playbooks.tar.gz'
qvm-run --pass-io "$ANSIBLE_DVM" "cat Playbooks.tar.gz" > "$HOME/Playbooks.tar.gz"
tar -xzf "$HOME/Playbooks.tar.gz"
rm '/tmp/Playbooks.tar.gz'
mv "$HOME/gas-station-master" "$HOME/Playbooks"

# Delete DispVM
qvm-kill "$ANSIBLE_DVM"

# Move files to appropriate locations
sudo rm -rf '/etc/ansible'
sudo mv Playbooks '/etc/ansible'
ansible-galaxy collection install -r /etc/ansible/collections/requirements.yml
sudo mkdir -p '/usr/share/ansible/plugins/connection'
sudo rm -rf '/usr/share/ansible/plugins/connection/qubes.py'
sudo ln -s '/etc/ansible/scripts/connection/qubes.py' '/usr/share/ansible/plugins/connection/qubes.py'
sudo mkdir -p '/usr/share/ansible/library'
sudo rm -rf '/usr/share/ansible/library/qubesos.py'
sudo ln -s '/etc/ansible/scripts/library/qubesos.py' '/usr/share/ansible/library/qubesos.py'

# Run the playbook
ansible-playbook -i /etc/ansible/inventories/quickstart.yml /etc/ansible/playbooks/qubes.yml
