## Code Format

We try to structure our Ansible task and variable files similarly across all our Ansible projects. This allows us to do things like use RegEx to make ecosystem wide changes. A good way of making sure that your code follows the format we are using is to clone the [main playbook repository]({{ repository.playbooks }}) and use Visual Studio Code to search for code examples of how we are performing similar tasks. For example:

* All of our roles use a similar pattern for the `tasks/main.yml` file
* The file names and variable names are consistent across our roles
* Contributors automatically format some parts of their code by leveraging our pre-commit hook (which is installed when you run `npm i` in the root of a project)

### Code Format Example

To dive a little deeper, take the following block of code that was retrieved from `tasks/main.yml` from the Android Studio role as an example:

```yaml
---
- name: Include variables based on the operating system
  include_vars: '{{ {{ ansible_os_family }} }}.yml'

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: 'install-{{ {{ ansible_os_family }} }}.yml'
```

Now, if you compare the block of code above to other `tasks/main.yml` files in other roles (which you can find in our [GitLab Ansible Roles group]({{ repository.group.ansible_roles }}) or our [main playbook]({{ repository.playbooks }})), you will see that the files are either identical or nearly identical. However, some roles will exclude the first task titled "Include variables based on the operating system" when variables are not required for the role. Our goal is to be consistent but not to the point where we are degrading the functionality of our code.

In general, it is up to the developer to browse through our projects to get a feel for the code format we use. A good idea is to clone the main playbook, then search for how Ansible modules are used, and then mimic the format. For instance, if you are adding a task that installs a snap package, then you would search for `community.general.snap:` in the main playbook to see the format we are using.

### Platform-Specific Roles

If you have a role that only installs software made for Windows 10 then ensure that the tasks are only run when the system is a Windows system by using `when:` in the `tasks/main.yml` file. Take the following `main.yml` as an example:

```yaml
---
- name: Include variables based on the operating system
  include_vars: "ansible_os_family.yml"
  when: ansible_os_family == 'Windows'

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: "install-ansible_os_family.yml"
  when: ansible_os_family == 'Windows'
```
