# Windows 10 Playbooks

## Initial Setup Required

Run the following commands as an Administrator in Powershell on the target Windows 10 machines:

1. Enable WinRM by running `WinRM qc`
2. Allow Powershell execution by running `Set-ExecutionPolicy` and then setting it to Bypass
3. Run `ConfigureRemotingForAnsible.ps1 -CertValidityDays 3650 -EnableCredSSP`

## Gotchas

On Mac OS X, run `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` before running an ansible-playbook when connecting to Parallels Windows.