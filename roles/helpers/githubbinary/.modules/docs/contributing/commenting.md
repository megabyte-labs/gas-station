## Commenting

We strive to make our roles easy to understand. Commenting is a major part of making our roles easier to grasp. Several types of comments are supported in such a way that they tie into our automated documentation generation system. This project uses [ansible-autodoc](https://github.com/AndresBott/ansible-autodoc) to scan through specially marked up comments and generate documentation out of them. The module also allows the use of markdown in comments so feel free to bold, italicize, and `code_block` as necessary. Although it is perfectly acceptable to use regular comments, in most cases, you should use one of the following types of *special* comments:

* [Variable comments](#variable-comments)
* [Action comments](#action-comments)
* [TODO comments](#todo-comments)

### Variable Comments

It is usually not necessary to add full-fledged comments to anything in the `vars/` folder but the `defaults/main.yml` file is a different story. The `defaults/main.yml` file must be fully commented since it is where we store all the variables that our users can customize. **`defaults/main.yml` is the only place where comments using the following format should be present.**

Each variable in `defaults/main.yml` should be added and documented using the following format:

```yaml
 # @var variable_name: default_value
 # The description of the variable which should be no longer than 160 characters per line.
 # You can seperate the description into new lines so you do not pass the 160 character
 # limit
 variable_name: default_value
```

There are cases where you may want include an example or you can not fit the default_value on one line. In cases like this, use the following format:

```yaml
 # @var variable_name: []
 # The description of the variable which should be no longer than 160 characters per line.
 # You can seperate the description into new lines so you do not pass the 160 character
 # limit
 variable_name: []
 # @example #
 # variable_name:
 #   - name: jimmy
 #     param: henry
 #   - name: albert
 # @end
```

Each variable/comment block in `defaults/main.yml` should be seperated by a line return. You can see an example of a `defaults/main.yml` file using this special [variable syntax in the Docker role](https://gitlab.com/ProfessorManhattan/Playbooks/-/blob/master/roles/virtualization/docker/defaults/main.yml).

### Action Comments

Action comments allow us to describe what the role does. Each action comment should include an action group as well as a description of the feature or "action". Most of the action comments should probably be added to the `tasks/main.yml` file although there could be cases where an action comment is added in a specific task file (like `install-Darwin.yml`, for instance). Action comments allow us to group similar tasks into lists under the action comment's group.

#### Example Action Comment Implementation

The following is an example of the implementation of action comments. You can find the [source here](https://gitlab.com/ProfessorManhattan/Playbooks/-/blob/master/roles/virtualization/docker/tasks/main.yml) as well as an example of why and how you would include an [action comment outside of the `tasks/main.yml` file here](https://gitlab.com/ProfessorManhattan/Playbooks/-/blob/master/roles/virtualization/docker/tasks/compose-Darwin.yml).

```yaml
 # @action Ensures Docker is installed
 # Installs Docker on the target machine.
 # @action Ensures Docker is installed
 # Ensures Docker is started on boot.
 - name: Include tasks based on the operating system
   block:
     - include_tasks: "install-{{ ansible_os_family }}.yml"
   when: not docker_snap_install

 # @action Ensures Docker is installed
 # If the target Docker host is a Linux machine and the `docker_snap_install` variable
 # is set to true, then Docker will be installed as a snap package.
 - name: Install Docker via snap
   community.general.snap:
     name: docker
   when:
     - ansible_os_family not in ('Windows', 'Darwin')
     - docker_snap_install

 # @action Installs Docker Compose
 # Installs Docker Compose if the `docker_install_compose` variable is set to true.
 - name: Install Docker Compose (based on OS)
   block:
     - include_tasks: "compose-{{ ansible_os_family }}.yml"
   when: docker_install_compose | bool
```

#### Example Action Comment Generated Output

The block of code above will generate markdown that would look similar to this:

**Ensures Docker is installed**

* Installs Docker on the target machine.
* Ensures Docker is started on boot.
* If the target Docker host is a Linux machine and the `docker_snap_install` variable is set to true, then Docker will be installed as a snap package.

**Installs Docker Compose**

* Installs Docker Compose if the `docker_install_compose` variable is set to true.

#### Action Comment Guidelines

* The wording of each action should be in active tense, describing a capability of the role. So instead of calling an action "Generate TLS certificates," we would call it, "Generates TLS certificates."
* The bulk of the action comments should be placed in the `tasks/main.yml` file. However, there may be use cases for putting an action comment in another file. For instance, if we did not support adding wildcard TLS certificates on Windows hosts only, then we might add an action comment to the `install-Windows.yml` file with the appropriate action section heading with further details.
* The goal of action comments are to present our users with some easy to understand bullet points about exactly what the role does and also elaborate on some of the higher-level technical details.

### TODO Comments

TODO comments are similar to action comments in the sense that through automation similar comments will be grouped together. You should use them anytime you find a bug, think of an improvement, spot something that needs testing, or realize there is a desirable feature missing. Take the following as an example:

#### Example TODO Comment Implementation

```yaml
 # @todo bug: bug description
 # @todo improvement: improvement description
 # @todo bug: another bug description
```

#### Example TODO Comment Generated Output

The above code will output something that looks like this:

**bug**

* bug description
* another bug description

**improvement**

* improvement description

#### TODO Comment Guidelines

* A TODO comment can be placed anywhere as long as no lines pass the limit of 160 characters.
* Try using similar TODO comment groups. Nothing is set in stone yet but try to use the following categories unless you really believe we need a new category:
  * bug
  * feature
  * improvement
  * test
