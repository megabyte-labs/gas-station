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

# Ensure sys-whonix is configured
CONFIG_WIZARD_COUNT=0
ENABLE_OBFSC='true'
function configureWizard() {
  if xwininfo -root -tree | grep "Anon Connection Wizard"; then
    WINDOW_ID="$(xwininfo -root -tree | grep "Anon Connection Wizard" | sed 's/^ *\([^ ]*\) .*/\1/')"
    xdotool windowactivate "$WINDOW_ID"
    sleep 0.5
    if [[ "$ENABLE_OBFSC" == 'true' ]]; then
      xdotool key 'Tab'
      xdotool key 'Tab'
      xdotool key 'Tab'
      xdotool key 'Down'
    fi
    xdotool key 'Enter'
    sleep 0.5
    if [[ "$ENABLE_OBFSC" == 'true' ]]; then
      xdotool key 'Space'
    fi
    xdotool key 'Tab'
    xdotool key 'Tab'
    xdotool key 'Enter'
    sleep 14
    xdotool windowactivate "$WINDOW_ID"
    sleep 0.5
    xdotool key 'Enter'
  else
    sleep 3
    CONFIG_WIZARD=$((CONFIG_WIZARD + 1))
    if [ "$CONFIG_WIZARD_COUNT" == '10' ]; then
      echo "anon-connection-wizard was probably already run."
    else
      configureWizard
    fi
  fi
}
configureWizard &
qvm-start sys-whonix --skip-if-running

# Download Gas Station and transfer to dom0 via DispVM
qvm-shutdown --force "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
qvm-remove --force "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
qvm-create --label red --template debian-11 "$ANSIBLE_DVM"
qvm-run "$ANSIBLE_DVM" 'curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/archive/master/gas-station-master.tar.gz > Playbooks.tar.gz'
qvm-run --pass-io "$ANSIBLE_DVM" "cat Playbooks.tar.gz" > "$HOME/Playbooks.tar.gz"
tar -xzf "$HOME/Playbooks.tar.gz"
rm -f "$HOME/Playbooks.tar.gz"
mv "$HOME/gas-station-master" "$HOME/Playbooks"

# Delete DispVM
qvm-kill "$ANSIBLE_DVM"

# Move files to appropriate locations
sudo rm -rf '/etc/ansible'
sudo mv "$HOME/Playbooks" '/etc/ansible'
cd '/etc/ansible/collections'
ansible-galaxy collection install -r /etc/ansible/collections/requirements.yml
sudo mkdir -p '/usr/share/ansible/plugins/connection'
sudo rm -rf '/usr/share/ansible/plugins/connection/qubes.py'
sudo ln -s '/etc/ansible/scripts/connection/qubes.py' '/usr/share/ansible/plugins/connection/qubes.py'
sudo mkdir -p '/usr/share/ansible/library'
sudo rm -rf '/usr/share/ansible/library/qubesos.py'
sudo ln -s '/etc/ansible/scripts/library/qubesos.py' '/usr/share/ansible/library/qubesos.py'

# Symlink the roles to their Galaxy alias
while read ROLE_PATH; do
  ROLE_FOLDER="professormanhattan.$(basename "$ROLE_PATH")"
  if [ ! -d "/etc/ansible/roles/$ROLE_FOLDER" ]; then
    rm -rf "/etc/ansible/roles/$ROLE_FOLDER"
    ln -sf "$ROLE_PATH" "/etc/ansible/roles/$ROLE_FOLDER"
  fi
done < <(find /etc/ansible/roles -mindepth 2 -maxdepth 2 -type d)

# Run the playbook
ANSIBLE_STDOUT_CALLBACK="default" ansible-playbook -i /etc/ansible/inventories/quickstart.yml /etc/ansible/playbooks/qubes.yml
