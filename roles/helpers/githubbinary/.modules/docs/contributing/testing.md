## Testing

You can test all of the operating systems we support by running the following command in the root of the project:

```shell
molecule test
```

The command `molecule test` will spin up VirtualBox VMs for all the OSes we support and run the role(s). *Do this before committing code.* If you are committing code for only one OS and can not create the fix or feature for the other operating systems then please [file an issue]({{ repository.playbooks }}/-/issues/new) so someone else can pick it up.

### Idempotence

It is important to note that `molecule test` tests for idempotence. To pass the idempotence test means that if you run the role twice in a row then Ansible should not report any changes the second time around.

### Debugging

If you would like to shell into a container for debugging, you can do that by running:

```shell
molecule converge # Creates the VM (without deleting it)
molecule login    # Logs you in via SSH
```

### Molecule Documentation

For more information about Ansible Molecule, check out [the docs](https://molecule.readthedocs.io/en/latest/).

### Testing Desktop Environments

Some of our roles include applications like Android Studio. You can not fully test Android Studio from a Docker command line. In cases like this, you should use our desktop scenarios to provision a desktop GUI-enabled VM to test things like:

* Making sure the Android Studio shortcut is in the applications menu
* Opening Android Studio to make sure it is behaving as expected
* Seeing if there is anything we can automate (e.g. if there is a "Terms of Usage" you have to click OK at then we should automate that process if possible)

You can specify which scenario you want to test by passing the `-s` flag with the name of the scenario you want to run. For instance, if you wanted to test on Ubuntu Desktop, you would run the following command:

```shell
molecule test -s ubuntu-desktop
```

This would run the Molecule test on Ubuntu Desktop.

By default, the `molecule test` command will destroy the VM after the test is complete. To run the Ubuntu Desktop test and then open the desktop GUI you would have to:

1. Run `molecule converge -s ubuntu-desktop`
2. Open the VM through the VirtualBox UI (the username and password are both *vagrant*)

You can obtain a list of all possible scenarios by looking in the `molecule/` folder. The `molecule/default/` folder is run when you do not pass a scenario. All the other scenarios can be run by manually specifying the scenario (i.e. folder name).
