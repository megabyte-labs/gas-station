Role Name: packer
=========

Role to install vagrant (Hashicorp) on multiple platforms

Requirements
------------
- chocolatey on Windows 10
- homebrew on MacOS
- yum on Redhat family
- apt and gpg on Debian family

Role Variables
--------------
Repository URL/setting has to be provided in the variable ending with _repo

Example Playbook
----------------

- hosts: servers
  roles:
    - role: vagrant
