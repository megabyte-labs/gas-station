#!/usr/bin/env bash

ANSIBLE_DVM="ansible-dvm"

set -ex

# Update dom0
if [ ! -f /tmp/dom0_updated ]; then
  echo "Updating dom0"
  sudo qubesctl --show-output state.sls update.qubes-dom0
  sudo qubes-dom0-update --clean -y
  touch /tmp/dom0_updated
fi

if [ ! -f /tmp/qubes_ansible_python_installed ]; then
  echo "Installing the Qubes ansible-python3 package"
  sudo qubes-dom0-update -y ansible-python3 # TODO: Add better check
  touch /tmp/qubes_ansible_python_installed
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
    CONFIG_WIZARD_COUNT=$((CONFIG_WIZARD_COUNT + 1))
    if [[ "$CONFIG_WIZARD_COUNT" == '4' ]]; then
      echo "The sys-whonix anon-connection-wizard utility did not open."
    else
      echo "Checking for anon-connection-wizard again.."
      configureWizard
    fi
  fi
}

# Ensure sys-whonix is running an configured
if ! qvm-check --running sys-whonix; then
  qvm-start sys-whonix --skip-if-running
  configureWizard > /dev/null
fi

# Download Gas Station and transfer to dom0 via DispVM
echo "Downloading Gas Station into dom0 via temporary VM"
if qvm-check "$ANSIBLE_DVM"; then
  qvm-shutdown --force "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
  sleep 1
  qvm-remove --force "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
  sleep 4
fi
qvm-create --label red --template debian-11 "$ANSIBLE_DVM"
qvm-run "$ANSIBLE_DVM" 'curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/archive/master/gas-station-master.tar.gz > Playbooks.tar.gz'
qvm-run --pass-io "$ANSIBLE_DVM" "cat Playbooks.tar.gz" > "$HOME/Playbooks.tar.gz"
tar -xzf "$HOME/Playbooks.tar.gz" -C "$HOME"
rm -f "$HOME/Playbooks.tar.gz"
mv "$HOME/gas-station-master" "$HOME/Playbooks"

# Delete DispVM
echo "Destroying temporary download VM"
qvm-shutdown --force "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
sleep 1
qvm-remove --force "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
sleep 4

# Move files to appropriate locations
echo "Unpacking Gas Station"
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
echo "Symlinking roles to their corresponding Ansible Galaxy folder names"
while read ROLE_PATH; do
  ROLE_FOLDER="professormanhattan.$(basename "$ROLE_PATH")"
  if [ ! -d "/etc/ansible/roles/$ROLE_FOLDER" ]; then
    rm -rf "/etc/ansible/roles/$ROLE_FOLDER"
    ln -sf "$ROLE_PATH" "/etc/ansible/roles/$ROLE_FOLDER"
  fi
done < <(find /etc/ansible/roles -mindepth 2 -maxdepth 2 -type d)

# Run the playbook
echo "Running the playbook.."
ANSIBLE_STDOUT_CALLBACK="default" ansible-playbook -i /etc/ansible/inventories/quickstart.yml /etc/ansible/playbooks/qubes.yml
