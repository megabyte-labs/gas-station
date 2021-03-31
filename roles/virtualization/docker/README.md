# Ansible Role: docker

Project description 

## Tags:
## Variables:

* `docker_edition`: `ce` - Edition can be either `ce` (Community Edition) or `ee` (Enterprise Edition).

example: 


```yaml
docker_edition:
  - subitem: string
  - subitem2: string
```

* `docker_package`: `docker-{{ docker_edition }}` - The name of the Docker package to install



* `docker_restart_handler_state`: `restarted` - The state that the Docker service should assume when a restart event is triggered



* `docker_install_compose`: `true` - Whether or not to install docker-compose



* `docker_compose_version`: `"1.26.0"` - The version of docker-compose that should be installed



* `docker_compose_path`: `/usr/local/bin/docker-compose` - The target destination of the docker-compose binary that will be installed



* `docker_apt_release_channel`: `stable` - The release channel to use on Debian/Ubuntu. You can set the value of this variable to either 'stable' or 'edge'.



* `docker_apt_arch`: `amd64` - The processor architecture to use



* `https_repository_prefix`: `https://` - Allows you to customize what the apt repository URL starts with. This is useful if you are using something like apt-cacher-ng as a proxy cache.



* `docker_apt_repository`: `*See defaults/main.yml*` - The apt repository to use



## Author Information
This role:  was created by: Author name

Documentation generated using: [Ansible-autodoc](https://github.com/AndresBott/ansible-autodoc)


--- CONVERT THE ABOVE TO THE FOLLOWING ---
## Variables

* **`docker_edition`**: `ce` - Edition can be either `ce` (Community Edition) or `ee` (Enterprise Edition).
  * **Example:**
  ```yaml
  docker_edition:
    - subitem: string
    - subitem2: string
  ```
* **`docker_package`**: `docker-{{ docker_edition }}` - The name of the Docker package to install
* **`docker_restart_handler_state`**: `restarted` - The state that the Docker service should assume when a restart event is triggered
* **`docker_install_compose`**: `true` - Whether or not to install docker-compose
* **`docker_compose_version`**: `"1.26.0"` - The version of docker-compose that should be installed
* **`docker_compose_path`**: `/usr/local/bin/docker-compose` - The target destination of the docker-compose binary that will be installed
* **`docker_apt_release_channel`**: `stable` - The release channel to use on Debian/Ubuntu. You can set the value of this variable to either 'stable' or 'edge'.
* **`docker_apt_arch`**: `amd64` - The processor architecture to use
* **`https_repository_prefix`**: `https://` - Allows you to customize what the apt repository URL starts with. This is useful if you are using something like apt-cacher-ng as a proxy cache.
* **`docker_apt_repository`**: `See defaults/main.yml` - The apt repository to use

