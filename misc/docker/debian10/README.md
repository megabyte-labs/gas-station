<h1 align="center">Welcome to Ansible Molecule Debian 10 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://gitlab.com/megabyte-space/dockerfile/ansible-molecule-debian-10/-/raw/master/LICENSE" target="_blank">
    <img alt="License: Megabyte Labs" src="https://img.shields.io/badge/License-Megabyte Labs-yellow.svg" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/follow/PrfssrManhattan.svg?style=social" />
  </a>
</p>

> This project houses a Dockerfile for creating an image that includes Ansible and the other required dependencies for testing a playbook with Molecule as well as linting it with tools like ansible-lint and yamllint. This project is based on [Jeff Geerling's role](https://github.com/geerlingguy/docker-debian10-ansible). It adds a user with sudo priviledges so that roles can be tested without running everything as root.

### 🏠 [Homepage](https://gitlab.com/megabyte-space/dockerfile/ansible-molecule-debian-10)

## Setup Instructions

1. Install the dependencies (Example: `sudo apt-get install python3 python3-pip`)
2. Install the pip dependencies (Example: `pip3 install ansible ansible-lint molecule yamllint`)
3. Create a role by running `molecule init role my_role_name`
4. Replace the `molecule.yml` in `my_role_name/molecule/default/molecule.yml` with something like the following:

```
---
dependency:
  name: galaxy
driver:
  name: docker
lint:
  name: yamllint
platforms:
  - name: CentOS 7
    image: centos:7
    command: ""
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    priviledged: true
    pre_build_image: true
  - name: CentOS 8
    image: centos:8
    command: ""
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    priviledged: true
    pre_build_image: true
  - name: Fedora 33
    image: fedora:33
    command: ""
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    priviledged: true
    pre_build_image: true
  - name: Ubuntu 20.04
    image: ubuntu:20.04
    command: ""
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    priviledged: true
    pre_build_image: true
provisioner:
  name: ansible
  lint:
    name: ansible-lint
  inventory:
    group_vars:
      server:
        motd: "Test test"
verifier:
  name: ansible
scenario:
  create_sequence:
    - dependency
    - create
    - prepare
  check_sequence:
    - dependency
    - cleanup
    - destroy
    - create
    - prepare
    - converge
    - check
    - destroy
  converge_sequence:
    - dependency
    - create
    - prepare
    - converge
  destroy_sequence:
    - dependency
    - cleanup
    - destroy
  test_sequence:
    - lint
    - dependency
    - cleanup
    - destroy
    - syntax
    - create
    - prepare
    - converge
    - idempotence
    - side_effect
    - verify
    - cleanup
    - destroy

```

## Usage

After the setup is finished, you can run the Molecule tests with the following command in the role's root directory:

```sh
molecule test
```

## Author

👤 **ProfessorManhattan**

* Website: [https://megabyte.space](https://megabyte.space)
* Twitter: [@PrfssrManhattan](https://twitter.com/PrfssrManhattan)
* Github: [@ProfessorManhattan](https://github.com/ProfessorManhattan)
* LinkedIn: [@blzalewski](https://linkedin.com/in/blzalewski)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://gitlab.com/megabyte-space/dockerfile/ansible-molecule-debian-10/-/issues). 

## Show your support

Give a ⭐️ if this project helped you!

<a href="https://www.patreon.com/ProfessorManhattan">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

## 📝 License

Copyright © 2020 [Megabyte Labs](https://megabyte.space), [Brian Zalewski](https://github.com/ProfessorManhattan), [Jeff Geerling](https://github.com/geerlingguy).<br />
This project is [MIT](https://gitlab.com/megabyte-space/dockerfile/ansible-molecule-debian-10/-/raw/master/LICENSE) licensed.
