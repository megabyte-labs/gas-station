#!/usr/bin/env bash

# The VM name that will manage the Ansible provisioning
ANSIBLE_PROVISION_VM="provision"
# Whether or not to use dom0 to run the Ansible play (WIP)
USE_DOM0="false"

set -ex

if [[ "$(hostname)" == "dom0" ]]; then
  # Symlink old Python binary
  if ! type python &> /dev/null; then
    sudo ln -s /usr/bin/python3 /usr/bin/python
  fi

  if [ ! -f ~/.vaultpass ]; then
    echo "Enter N to use a custom playbook with customizations like encrypted Ansible Vault secrets:"
    read -p "Use defaults? (Y/N): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
      echo "Using default playbook values. Check out the README for more information on customizing the playbook to setup API key-related services / apps."
    else
      echo "NOTE: To customize the playbook repository used, you will have to edit the repository specified in this script."
      read -p "Enter Vault password: " ANSIBLE_VAULT_PASS
      echo "$ANSIBLE_VAULT_PASS" > ~/.vaultpass
    fi
  else
    echo "Reading previously entered Ansible Vault password from ~/.vaultpass"
    ANSIBLE_VAULT_PASS="$(cat ~/.vaultpass)"
  fi

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
      if [ "$ENABLE_OBFSC" == 'true' ]; then
        xdotool key 'Tab'
        xdotool key 'Tab'
        xdotool key 'Tab'
        xdotool key 'Down'
      fi
      xdotool key 'Enter'
      sleep 1
      if [ "$ENABLE_OBFSC" == 'true' ]; then
        xdotool key 'space'
      fi
      xdotool key 'Tab'
      xdotool key 'Tab'
      xdotool key 'Enter'
      sleep 1
      if [ "$ENABLE_OBFSC" == 'true' ]; then
        xdotool key 'Tab'
        xdotool key 'Tab'
        xdotool key 'Enter'
        sleep 1
        xdotool key 'Tab'
        xdotool key 'Tab'
        xdotool key 'Enter'
      fi
      sleep 14
      xdotool windowactivate "$WINDOW_ID"
      sleep 1
      xdotool key 'Enter'
      # TODO: Add logic to recursively check for presence of WINDOW_ID_SYSCHECK
      if [ "$ENABLE_OBFSC" == 'true' ]; then
        sleep 480
      else
        sleep 140
      fi
      WINDOW_ID_SYSCHECK="$(xwininfo -root -tree | grep "systemcheck | Whonix" | sed 's/^ *\([^ ]*\) .*/\1/')"
      xdotool windowactivate "$WINDOW_ID_SYS_CHECK"
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
    while read RESTART_VM; do
      qvm-shutdown --wait "$RESTART_VM"
    done< <(qvm-ls --all --no-spinner --fields=name,state | grep Running | grep -v sys-net | grep -v sys-firewall | grep -v sys-whonix | grep -v dom0 | awk '{print $1}')
    touch /tmp/templatevms_updated
  fi

  echo "/bin/bash" | sudo tee /etc/qubes-rpc/qubes.VMShell
  sudo chmod 755 /etc/qubes-rpc/qubes.VMShell
  echo "$ANSIBLE_PROVISION_VM"' dom0 allow' | sudo tee /etc/qubes-rpc/policy/qubes.VMShell
  echo "$ANSIBLE_PROVISION_VM"' $anyvm allow' | sudo tee -a /etc/qubes-rpc/policy/qubes.VMShell
  sudo chown "$(whoami):$(whoami)" /etc/qubes-rpc/policy/qubes.VMShell
  sudo chmod 644 /etc/qubes-rpc/policy/qubes.VMShell
fi

if [[ "$USE_DOM0" == "true" ]] && [[ "$(hostname)" == "dom0" ]]; then
  # Download Gas Station and transfer to dom0 via DispVM
  qvm-create --label red --template debian-11 "$ANSIBLE_PROVISION_VM" &> /dev/null || EXIT_CODE=$?
  qvm-run "$ANSIBLE_PROVISION_VM" 'curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/archive/master/gas-station-master.tar.gz > ~/Downloads/Playbooks.tar.gz'
  mkdir -p "$HOME/.local/src"
  qvm-run --pass-io "$ANSIBLE_PROVISION_VM" "cat ~/.local/src/Playbooks.tar.gz" > "$HOME/.local/src/Playbooks.tar.gz"
  tar -xzf "$HOME/.local/src/Playbooks.tar.gz" -C "$HOME"
  rm -f "$HOME/.local/src/Playbooks.tar.gz"
  mv "$HOME/gas-station-master" "$HOME/Playbooks"
  qvm-run "$ANSIBLE_PROVISION_VM" 'curl -sSL https://github.com/ProfessorManhattan/ansible-qubes/archive/refs/heads/master.tar.gz > ~/Downloads/ansible-qubes.tar.gz'
  qvm-run --pass-io "$ANSIBLE_PROVISION_VM" "cat ~/Downloads/ansible-qubes.tar.gz" > "$HOME/.local/src/ansible-qubes.tar.gz"
  tar -xzf "$HOME/.local/src/ansible-qubes.tar.gz" -C "$HOME"
  rm -f "$HOME/.local/src/ansible-qubes.tar.gz"
  sudo rm -rf "$HOME/Playbooks/.modules/ansible-qubes"
  mv "$HOME/ansible-qubes-master" "$HOME/Playbooks/.modules/ansible-qubes"
  # Move files to appropriate locations
  echo "Unpacking Gas Station"
  if [ -d "/etc/ansible/facts.d" ]; then
    cp -rf /etc/ansible/facts.d "$HOME/Playbooks/facts.d"
  fi
  sudo rm -rf '/etc/ansible'
  sudo mv "$HOME/Playbooks" '/etc/ansible'
else
  if [[ "$(hostname)" == "dom0" ]]; then
    qvm-create --label red --template debian-11 "$ANSIBLE_PROVISION_VM" &> /dev/null || EXIT_CODE=$?
    qvm-volume extend "$ANSIBLE_PROVISION_VM:private" "40G"
    qvm-run --pass-io "$ANSIBLE_PROVISION_VM" 'curl -sSL https://install.doctor/qubes > ~/provision.sh && bash ~/provision.sh'
    # TODO - Copy ~/.vaultpass from DOM0 to provision VM
    if [ -f ~/.vaultpass ]; then
      qvm-run "$ANSIBLE_PROVISION_VM" 'rm -f ~/QubesIncoming/dom0/.vaultpass'
      qvm-copy-to-vm "$ANSIBLE_PROVISION_VM" ~/.vaultpass
      qvm-run "$ANSIBLE_PROVISION_VM" 'cp ~/QubesIncoming/dom0/.vaultpass ~/.vaultpass'
    fi
    exit 0
  else
    echo "Ensuring Ansible is installed"
    sudo apt-get install -y ansible
    if [ -d /etc/ansible/playbooks ]; then
      cd /etc/ansible
      sudo git config pull.rebase false
      sudo git pull origin master
      cd /etc/ansible/.modules/ansible-qubes
      sudo git config pull.rebase false
      sudo git pull origin master
    else
      if [ -d "/etc/ansible/facts.d" ]; then
        cp -rf /etc/ansible/facts.d /tmp/ansible-facts
      fi
      sudo rm -rf /etc/ansible
      cd /etc
      sudo git clone https://gitlab.com/megabyte-labs/gas-station.git ansible
      if [ -d "/etc/ansible/facts.d" ]; then
        cp -rf /tmp/ansible-facts /etc/ansible/facts.d
      fi
      sudo rm -rf /etc/ansible/.modules/ansible-qubes
      cd /etc/ansible/.modules
      sudo git clone https://github.com/ProfessorManhattan/ansible-qubes.git ansible-qubes
    fi
  fi
fi

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
    sudo rm -rf "/etc/ansible/roles/$ROLE_FOLDER"
    sudo ln -sf "$ROLE_PATH" "/etc/ansible/roles/$ROLE_FOLDER"
  fi
done < <(find /etc/ansible/roles -mindepth 2 -maxdepth 2 -type d)

# Symlink the Qubes playbook
sudo rm -f '/etc/ansible/qubes.yml'
sudo ln -s '/etc/ansible/playbooks/qubes.yml' '/etc/ansible/qubes.yml'

# Install Ansible collections
cd '/etc/ansible/collections'
ansible-galaxy collection install --force -r requirements.yml

# Run the playbook
echo "Your Ansible Vault password should be placed at ~/.vaultpass"
cd /etc/ansible
if [[ "$(hostname)" == 'dom0' ]]; then
  export ANSIBLE_STDOUT_CALLBACK="default"
fi
ansible-playbook --vault-password-file ~/.vaultpass -i /etc/ansible/inventories/quickstart.yml /etc/ansible/qubes.yml | tee ~/ansible-log.txt
