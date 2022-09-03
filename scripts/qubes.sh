#!/usr/bin/env bash

ANSIBLE_DVM="download-vm"

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
    sleep 1
    if [[ "$ENABLE_OBFSC" == 'true' ]]; then
      xdotool key 'Tab'
      xdotool key 'Tab'
      xdotool key 'Tab'
      xdotool key 'Down'
    fi
    xdotool key 'Enter'
    sleep 2
    if [[ "$ENABLE_OBFSC" == 'true' ]]; then
      xdotool key 'Space'
    fi
    xdotool key 'Tab'
    xdotool key 'Tab'
    xdotool key 'Enter'
    sleep 14
    xdotool windowactivate "$WINDOW_ID"
    sleep 1
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

if [ ! -f /tmp/templatevms_updated ]; then
  sudo qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm &> /dev/null || EXIT_CODE=$?
  I=$(qvm-ls --all --no-spinner --fields=name,state | grep Running | awk '{print $1}'); qvm-shutdown --wait --all ; echo $I | xargs -I{} qvm-start {}
  touch /tmp/templatevms_updated
fi

# Download Gas Station and transfer to dom0 via DispVM
qvm-create --label red --template debian-11 "$ANSIBLE_DVM" &> /dev/null || EXIT_CODE=$?
qvm-run "$ANSIBLE_DVM" 'curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/archive/master/gas-station-master.tar.gz > Playbooks.tar.gz'
qvm-run --pass-io "$ANSIBLE_DVM" "cat Playbooks.tar.gz" > "$HOME/Playbooks.tar.gz"
tar -xzf "$HOME/Playbooks.tar.gz" -C "$HOME"
rm -f "$HOME/Playbooks.tar.gz"
mv "$HOME/gas-station-master" "$HOME/Playbooks"
qvm-run "$ANSIBLE_DVM" 'curl -sSL https://github.com/Rudd-O/ansible-qubes/archive/refs/heads/master.tar.gz > ansible-qubes.tar.gz'
qvm-run --pass-io "$ANSIBLE_DVM" "cat ansible-qubes.tar.gz" > "$HOME/ansible-qubes.tar.gz"
tar -xzf "$HOME/ansible-qubes.tar.gz" -C "$HOME"
rm -f "$HOME/ansible-qubes.tar.gz"
sudo rm -rf "$HOME/Playbooks/.modules/ansible-qubes"
mv "$HOME/ansible-qubes-master" "$HOME/Playbooks/.modules/ansible-qubes"

# Move files to appropriate locations
echo "Unpacking Gas Station"
sudo rm -rf '/etc/ansible'
sudo mv "$HOME/Playbooks" '/etc/ansible'

# Install Ansible collections
cd '/etc/ansible/collections'
ansible-galaxy collection install -r /etc/ansible/collections/requirements.yml

# Ansible action plugins
sudo mkdir -p '/usr/share/ansible/plugins/action'
for ACTION_PLUGIN in 'commonlib.py' 'qubes_pass.py' 'qubesformation.py' 'qubesguid.py' 'qubessls.py'; do
  sudo rm -f "/usr/share/ansible/plugins/action/$ACTION_PLUGIN"
  sudo ln -s "/etc/ansible/.modules/ansible-qubes/action_plugins/$ACTION_PLUGIN" "/usr/share/ansible/plugins/action/$ACTION_PLUGIN"
done

# Ansible connection plugins
sudo mkdir -p '/usr/share/ansible/plugins/connection'
sudo rm -f '/usr/share/ansible/plugins/connection/qubes.py'
sudo ln -s '/etc/ansible/.modules/ansible-qubes/connection_plugins/qubes.py' '/usr/share/ansible/plugins/connection/qubes.py'

# Ansible lookup plugins
sudo mkdir -p '/usr/share/ansible/plugins/lookup'
for LOOKUP_PLUGIN in 'jq.py' 'qubes-pass.py'; do
  sudo rm -f "/usr/share/ansible/plugins/lookup/$LOOKUP_PLUGIN"
  sudo ln -s "/etc/ansible/.modules/ansible-qubes/lookup_plugins/$LOOKUP_PLUGIN" "/usr/share/ansible/plugins/lookup/$LOOKUP_PLUGIN"
done

# Ansible library
sudo mkdir -p '/usr/share/ansible/library'
sudo rm -f '/usr/share/ansible/library/qubesos.py'
sudo ln -s '/etc/ansible/scripts/library/qubesos.py' '/usr/share/ansible/library/qubesos.py'
for ANSIBLE_LIBRARY in 'qubes-pass.py' 'qubesformation.py' 'qubesguid.py' 'qubessls.py'; do
  sudo rm -f "/usr/share/ansible/library/$ANSIBLE_LIBRARY"
  sudo ln -s "/etc/ansible/.modules/ansible-qubes/library/$ANSIBLE_LIBRARY" "/usr/share/ansible/library/$ANSIBLE_LIBRARY"
done

# Ansible Qubes executables
for BIN_FILE in 'bombshell-client' 'qrun' 'qscp' 'qssh'; do
  sudo cp -f "/etc/ansible/.modules/ansible-qubes/bin/$BIN_FILE" "/usr/bin/$BIN_FILE"
  sudo chmod +x "/usr/bin/$BIN_FILE"
done

# Symlink the roles to their Galaxy alias
echo "Symlinking roles to their corresponding Ansible Galaxy folder names"
while read ROLE_PATH; do
  ROLE_FOLDER="professormanhattan.$(basename "$ROLE_PATH")"
  if [ ! -d "/etc/ansible/roles/$ROLE_FOLDER" ]; then
    rm -rf "/etc/ansible/roles/$ROLE_FOLDER"
    ln -sf "$ROLE_PATH" "/etc/ansible/roles/$ROLE_FOLDER"
  fi
done < <(find /etc/ansible/roles -mindepth 2 -maxdepth 2 -type d)

# Symlink the Qubes playbook
sudo rm -f '/etc/ansible/qubes.yml'
sudo ln -s '/etc/ansible/playbooks/qubes.yml' '/etc/ansible/qubes.yml'

# Run the playbook
echo "Your Ansible Vault password should be placed at ~/.vaultpass"
ANSIBLE_STDOUT_CALLBACK="default" ansible-playbook --vault-password-file ~/.vaultpass -i /etc/ansible/inventories/quickstart.yml /etc/ansible/qubes.yml
