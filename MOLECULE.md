# Using Molecule

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
