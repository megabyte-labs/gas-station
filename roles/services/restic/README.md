Ansible Role: restic
=========

Install restic backup software on different platforms.

Supported platforms:

|     Name    	|    Version    	|
|:-----------:	|:-------------:	|
| RHEL/CentOS 	|       8       	|
|    Fedora   	|       32      	|
|    Ubuntu   	| 20.04 [Focal] 	|
|  Archlinux  	|      all      	|
|   Windows   	|       10      	|
|    MacOS    	|     Mojave    	|

---


Dependencies
------------
- docker

Requirements
------------

- On Windows `Scoop` must be installed
- On MacOS `Homebrew` must be installed


Example Playbook
----------------

```yml
- hosts: all
  roles:
    - restic
```


License
-------

GPL

Author Information
------------------

Created by [theJaxon](https://github.com/theJaxon)