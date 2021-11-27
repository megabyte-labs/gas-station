# Architecture

This project is massive but the architecture is relatively simple especially to those who are already familiar with Ansible. The following gives a high-level overview of what each main folder does:

#### `environment/`

**`environment/dev/`**

This folder contains `host_vars/`, `group_vars/`, `inventories/`, and some other folders that are symlinked into the structure that Ansible expects. The `dev/` folder is symlinked to by default. Using this environment is a great starting point before deep-diving into adding customizations to the playbook.

**`environment/prod/`**

This folder contains `host_vars/`, `group_vars/`, `inventories/`, and some other folders that are symlinked into the structure that Ansible expects. This folder is meant to be a submodule that you link to a private git repository that houses your Ansible vault-encrypted secrets.

#### `files/`

This folder contains miscellaneous files that are used by various features provided by this project. By default, we also store encrypted SSH and VPN configuration files in subdirectories in this folder.

**`files/ssh/`**

This folder houses all the SSH private and public keys that you might want the playbook to propagate to other machines. You can change the path of this folder as it is not Ansible-specific.

**`files/vpn/`**

This folder contains VPN connection profiles that you may want to propagate to your client systems.

#### `group_vars/`

The `group_vars/` folder contains YML files that assign variables to targets in certain groups. This folder name is Ansible-specific (i.e. it is where Ansible searches for group variables by default). Applying variables using `group_vars/` allows you to assign variables such as NPM packages to install across multiple target machines.

Each group can either be in the format of `group_name.yml` or `group_name/*.yml`. The latter allows you to split the variable files into multiple files. This is beneficial when you want to use `ansible-vault` selectively encrypt some of the yml files included for a group.

**Example: `group_vars/desktop/`**

For example, this folder contains variables used for targets in the "desktop" group.

#### `host_vars/`

The `host_vars/` folder is similar to the `group_vars/` folder except the variables it defines are only applied to specific hosts.

**Example: `host_vars/workstation/`**

For example, this folder contains variables used for the "workstation" target (as defined in the `inventories/` folder).

#### `inventories/`

The `inventories/` folder is where you define your hosts. Each host should include the user you want Ansible to use to provision the environment, the sudo password, other connection details like IP address, as well as other connection related details like whether or not to use WinRM (the preferred method for remotely connecting to Windows environments).

Normally, you specify an inventory when you run Ansible. The files in this folder allow you to target specific hosts that you define.

#### `misc/`

The `misc/` folder contains miscellaneous files used for developing this project. You can ignore this folder.

#### `molecule/`

The `molecule/` folder contains test instructions for the automated testing of our playbooks and roles. Our Molecule scenarios leverage Docker and VirtualBox to ensure that roles and playbooks run without error.

#### `playbooks/`

The `playbooks/` folder contains various playbooks that are leveraged by the main playbook in order to improve readability.

#### `roles/`

The `roles/` folder contains all the roles that are used in our `main.yml` playbook. In order to reduce the cluttery appearance, we categorized our roles to use subdirectories by updating the `ansible.cfg` file. So in the `roles/` folder you will see group folders and in those folders you can see each role.
