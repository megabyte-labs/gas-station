Role Name: packer
=========

Role to install Yarn package manager on multiple platforms

Requirements
------------
- chocolatey on Windows 10
- homebrew on MacOS
- yum on Redhat family
- apt and gpg on Debian family
- pacman on Archlinux

Role Variables
--------------
Repository URL/setting has to be provided in the variable ending with _repo
Provide the pre-requisite packages in the variable named so and the package name against the variable named so

Example Playbook
----------------

- hosts: servers
  roles:
    - role: yarn
