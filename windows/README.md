# Windows 10 Playbooks

## Initial Setup Required

Run the following commands as an Administrator in Powershell on the target Windows 10 machines:

```
ConfigureRemotingForAnsible.ps1 -EnableCredSSP
```

## Gotchas

On Mac OS X, run `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` before running an ansible-playbook when connecting to Parallels Windows.