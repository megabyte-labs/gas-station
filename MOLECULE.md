# Using Molecule

All Molecule tests should include tests for the following environments:

## Supported Operating Systems

- CentOS 8
- Debian 10 (buster)
- Ubuntu 20.04 (focal)
- Fedora 33
- Latest Archlinux

## Test-Only Operating Systems

_The following operating systems should be included in Molecule tests at the latest version but are not officially supported:_

- Elementary OS
- Zorin
- OpenSUSE
- Manjaro
- Mint

On top of that, the tests should run on Mac OS X and Windows through Travis. [This link](https://docs.travis-ci.com/user/multi-os/) describes some of the basics that will be involved with this.

## Getting Started

It is highly recommended to install `molecule` in a Python virtual environment.
To setup the `molecule` enviroment run the following commands.

```terminal
python3 -m venv venv
source venv/bin/activate
```

Now the required packages can be installed by using the _molecule-requirements.txt_
file.

```terminal
pip install -r molecule-requirements.txt
```

A working example of `molecule` can be found at _roles/system/firewall_.

```terminal
cd roles/system/firewall
molecule test
```

By default `molecule` will use `docker` to create the systems, apply the playbooks
and run through the test matix.

For more information refer to the [documentation](https://molecule.readthedocs.io/en/latest/)
