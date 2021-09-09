## Managing Environments

We accomplish managing different environments through symlinking. In the `environments/` folder, you will see multiple options. In our case, `environments/dev/` contains sensible configurations for testing the playbook and its' roles. The production environment is a seperate git submodule that links to a private git repository that contains our Ansible-vaulted API keys and passwords. When you are ready to set up your production configurations, we recommend you follow this method as well. 

There are two shell scripts in the root of this repository called `setup-dev.sh` and `setup-prod.sh`. Those scripts show an example of symlinking your environment files.