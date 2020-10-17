Ansible Role: NGINX Optimized
=========

### NOT READY FOR USE - FOR REFERENCE ONLY

In its entireity, this role will:

* Install [NGINX](https://www.nginx.com/) and load an optimized set of base configurations that improve security and performance. You can customize this set of base configurations by cloning the linked repository and pointing the variable `optimized_nginx_repository` to your repository.
* Provide a way to easily manage site configurations by allowing you to store your .conf files in your Playbook
* Install [NGINX Amplify](https://www.nginx.com/products/nginx-amplify/) for performance metrics monitoring
* Automatically encrypt a wildcard SSL certificate so that you can provide properly signed HTTPS certificates for all of `*.lab.myhome.com` domains, for example
* Compile [Brotli](https://github.com/google/ngx_brotli) from source and include the appropriate modules/configurations in the NGINX configurations
* Compile [ModSecurity](https://github.com/SpiderLabs/ModSecurity) from source and generate the appropriate dynamic NGINX modules. Uses the default rules provided by [OWASP ModSecurity Core Rule Set](https://owasp.org/www-project-modsecurity-core-rule-set/).

This role will install [NGINX](https://www.nginx.com/) on Ubuntu 20.04 (only tested version) and load an "optimized" set of NGINX configurations/snippets via git. The configurations/snippets will pull from the master branch of [my preferred configurations](https://gitlab.com/megabyte-space/cloud/nginx) but you can override the repository with your own. The configurations were developed by using the best practices which are found in various popular NGINX configuration boilerplates available on GitHub.

Examples of the NGINX boilerplates used for inspiration:

* [https://github.com/h5bp/server-configs-nginx](https://github.com/h5bp/server-configs-nginx)
* [https://github.com/digitalocean/nginxconfig.io](https://github.com/digitalocean/nginxconfig.io)

Also, some useful suggestions were used from the following links:

* [https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration)
* [https://gist.github.com/denji/8359866](https://gist.github.com/denji/8359866)

This role will also install NGINX Amplify if you define the API key (example in `defaults/main.yml`). To get an API key, head over to [NGINX Amplify](https://amplify.nginx.com/dashboard).

This role will also automatically set up a wildcard SSL certificate, complete with auto-renewing capabilities. This part of the code is mainly derived from [ansible-role-certbot-cloudflare](https://github.com/michaelpporter/ansible-role-certbot-cloudflare) which utilizes [geerlingguy.certbot](https://github.com/geerlingguy/ansible-role-certbot). This part of the script will run if you define  `certbot_dns_cloudflare_api_token`. You can follow the [instructions specified here](https://github.com/nodecraft/acme-dns-01-cloudflare) to limit the scope of what the API token can do. Ideally, you should limit the zone priviledge to only the domain you need a wildcard certificate for. This role modifies [ansible-role-certbot-cloudflare](https://github.com/michaelpporter/ansible-role-certbot-cloudflare) to use python3 instead of python2.

Requirements
------------

None. If you notice that anything is missing, please open an issue. It is possible that the role is missing key dependencies like git that are almost always already installed on a system.

Role Variables
--------------

You can customize the following variables which are viewable in `defaults/main.yml`:

```
nginx_config_path: files/nginx        # Path to the .conf files in your Playbook
nginx_sites_available: []             # List of .conf files for NGINX to have ready
nginx_sites_enabled: []               # List of .conf files for NGINX to serve
nginx_clear_sites_available: no       # Whether or not to remove all the existing symlinks in sites-available when running this role
nginx_clear_sites_enabled: no         # Whether or not to remove all the current configs in sites-enabled when this role runs
#nginx_amplify_api_key:               # Fill this in with your NGINX Amplify API key to enable this service
optimized_nginx_repository: https://gitlab.com/megabyte-space/cloud/nginx.git # Repository to use for the base nginx configurations/snippets
optimized_nginx_repository_version: master                                    # Repository branch to use
```

There are more configurations to modify if you would like to configure an SSL wildcard or disable/enable the Brotli compression NGINX modules.

Dependencies
------------

* [geerlingguy.certbot](https://github.com/geerlingguy/ansible-role-certbot) - Used for configuring automatic renewal of Let's Encrypt wildcard certificates

Example Playbook
----------------

```
- hosts: servers
  become: yes
  tasks:
    name: Install NGINX with an optimized base configuration
    include_role:
      name: professormanhattan.ansible_nginx_optimized
    when: (nginx_sites_available | default([])) | length
```

License
-------

MIT

Author Information
------------------

This role was created by [Brian Zalewski](https://github.com/ProfessorManhattan) as a [Megabyte LLC](https://megabyte.space) production.
