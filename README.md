<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-readme-playbook.md" ⚠️--><div align="center">
  <center>
    <a href="https://github.com/ProfessorManhattan/Gas-Station">
      <img width="148" height="148" alt="Gas Station logo" src="https://gitlab.com/megabyte-labs/gas-station/-/raw/master/logo.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center">Ansible Playbook: Gas Station ⛽<i></i></h1></center>
  <center><h4 style="color: #18c3d1;">Brought to you by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4><i></i></center>
</div>

<div align="center">
  <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style=for-the-badge" />
  </a>
  <a href="https://github.com/ProfessorManhattan/Gas-Station/blob/master/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/ProfessorManhattan/Gas-Station" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style=for-the-badge" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/gas-station" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style=for-the-badge" />
  </a>
</div>
<br/>
<div align="center">
  <a title="Version: 0.0.1" href="https://github.com/ProfessorManhattan/Gas-Station" target="_blank">
    <img alt="Version: 0.0.1" src="https://img.shields.io/badge/version-0.0.1-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAACNJREFUCNdjIACY//+BEp9hhM3hAzYQwoBIAqEDYQrCZLwAAGlFKxU1nF9cAAAAAElFTkSuQmCC&cacheSeconds=2592000&style=flat-square" />
  </a>
  <a title="Build status" href="https://gitlab.com/megabyte-labs/gas-station/-/commits/master" target="_blank">
    <img alt="Build status" src="https://img.shields.io/gitlab/pipeline-status/megabyte-labs/gas-station?branch=master&label=build&logo=gitlab&style=flat-square">
  </a>
  <a title="E2E test status for all operating systems" href="https://gitlab.com/megabyte-labs/gas-station/-/commits/e2e" target="_blank">
    <img alt="E2E test status" src="https://img.shields.io/gitlab/pipeline-status/megabyte-labs/gas-station?branch=e2e&label=e2e%20test&logo=virtualbox&style=flat-square">
  </a>
  <a title="Documentation" href="https://megabyte.space/docs/ansible" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg?logo=readthedocs&style=flat-square" />
  </a>
  <a title="License: MIT" href="https://github.com/ProfessorManhattan/Gas-Station/blob/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-yellow.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHpJREFUCNdjYOD/wMDAUP+PgYHxhzwDA/MB5gMM7AwMDxj4GBgKGGQYGCyAEEgbMDDwAAWAwmk8958xpIOI5zKH2RmOyhxmZjguAiKmgIgtQOIYmFgCIp4AlaQ9OczGkJYCJEAGgI0CGwo2HmwR2Eqw5SBnNIAdBHYaAJb6KLM15W/CAAAAAElFTkSuQmCC&style=flat-square" />
  </a>
</div>

> <br/>**A no-stone-unturned Ansible playbook you can use to set up the ultimate home lab or on-premise addition to your cloud!**<br/><br/>

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Introduction](#introduction)
- [Quick Start](#quick-start)
  - [Vagrant (Recommended)](#vagrant-recommended)
  - [macOS/Linux](#macoslinux)
  - [Windows](#windows)
- [Supported Operating Systems](#supported-operating-systems)
- [Requirements](#requirements)
  - [Host Requirements](#host-requirements)
    - [Easier Method of Installing the Host Requirements](#easier-method-of-installing-the-host-requirements)
  - [Operating System](#operating-system)
  - [Connection](#connection)
  - [MAS on Mac OS X](#mas-on-mac-os-x)
- [Software](#software)
  - [Binaries](#binaries)
  - [NPM Packages](#npm-packages)
  - [Python Packages](#python-packages)
  - [Ruby Gems](#ruby-gems)
  - [Visual Studio Code Extensions](#visual-studio-code-extensions)
  - [Chrome Extensions](#chrome-extensions)
  - [Homebrew Formulae (macOS and Linux only)](#homebrew-formulae-macos-and-linux-only)
  - [Homebrew Casks (macOS only)](#homebrew-casks-macos-only)
  - [Go, Rust, and System-Specific Packages](#go-rust-and-system-specific-packages)
- [Web Applications](#web-applications)
  - [Helm Charts](#helm-charts)
  - [Host Applications](#host-applications)
    - [HTPC](#htpc)
- [Philosophy](#philosophy)
- [Architecture](#architecture)
- [Managing Environments](#managing-environments)
  - [Switching Between Environments](#switching-between-environments)
- [Contributing](#contributing)
- [License](#license)

<a href="#introduction" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Introduction

Welcome to a new way of doing things. Born out of complete paranoia and a relentless pursuit of the best of GitHub Awesome lists, Gas Station aims to add the capability of being able to completely wipe whole networks and restore them on a regular basis. It takes a unique approach to network provisioning because it supports desktop provisioning as a first-class citizen. By default, without much configuration, it is meant to provision and maintain the state of a network that includes development workstations and servers. One type of user that might benefit from this project is a web developer who wants to start saving the state of their desktop as code. Another type of user is one who wants to start hosting RAM-intensive web applications in their home-lab environment to save huge amounts on cloud costs. This project is also meant to be maintainable by a single person. Granted, if you look through our eco-system you will see we are well-equipped for supporting entire teams as well.

Gas Station a collection of Ansible playbooks, configurations, scripts, and roles meant to provision computers and networks with the "best of GitHub". By leveraging Ansible, you can provision your whole network relatively fast in the event of a disaster or scheduled network reset. This project is also intended to increase the security of your network by allowing you to frequently wipe, reinstall, and re-provision your network, bringing it back to its original state. This is done by backing up container storage volumes (like database files and Docker volumes) to encrypted S3 buckets, storing configurations in encrypted git repositories, and leveraging GitHub-sourced power tools to make the job easy-peasy.

This project started when a certain somebody changed their desktop wallpaper to an _cute_ picture of a cat 🐱 when, all of a sudden, their computer meowed. Well, it actually started before that but no one believes someone who claims that time travelers hacked them on a regular basis. _Tip: If you are stuck in spiritual darkness involving time travelers, save yourself some headaches by adopting an other-people first mentality that may include volunteering, tithing, and surrendering to Jesus Christ._ Anyway, enough preaching!

Gas Station is:

- Highly configurable - most roles come with optional variables that you can configure to change the behavior of the role
- Highly configured - in-depth research is done to ensure each software component is configured with bash completions, plugins that are well-received by the community, and integrated with other software used in the playbook
- Compatible with all major operating systems (i.e. Windows, Mac OS X, Ubuntu, Fedora, CentOS, Debian, and even Archlinux)
- The product of a team of experts
- An amazing way to learn about developer tools that many would consider to be "the best of GitHub"
- Open to new ideas - feel free to [open an issue](https://gitlab.com/megabyte-labs/gas-station/-/issues) or [contribute](https://github.com/ProfessorManhattan/Gas-Station/blob/master/CONTRIBUTING.md) with a [pull request](https://github.com/ProfessorManhattan/Gas-Station/issues)!

<a href="#quick-start" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Quick Start

The easiest way to run the entire playbook, outlined in the `main.yml` file, is to run the appropriate command listed below. These commands will run the playbook on the machine you run the command on. This is probably the best way to get your feet wet before you decide to give us a ⭐ and customize the playbook for your own needs. Ideally, this command should be run on the machine that you plan on running Ansible with to provision the other computers on your network. It is only guaranteed to work on fresh installs so testing it out with [Vagrant](https://www.vagrantup.com/) is highly encouraged.

### Vagrant (Recommended)

To test it out with Vagrant, you can run the following commands which will open up an interactive dialog where you can pick which operating system and virtualization provider you wish to test the installation with:

```shell
bash .config/scripts/start.sh # Only required if you do not have the dependencies (i.e. Task) already installed
task ansible:test:vagrant
```

### macOS/Linux

```shell
curl -sS https://gitlab.com/megabyte-labs/gas-station/-/raw/master/files/quickstart.sh | bash
```

### Windows

In an administrative PowerShell session, run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://gitlab.com/megabyte-labs/gas-station/-/raw/master/files/quickstart.ps1'))
```

<a href="#supported-operating-systems" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Supported Operating Systems

The following chart shows the operating systems that have been tested for compatibility using the `environments/dev/` environment. This chart is automatically generated using the Ansible Molecule tests you can view in the `molecule/default/` folder. We currently have logic in place to automatically handle the testing of Windows, Mac OS X, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it might still work.

compatibility_matrix

<a href="#requirements" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Requirements

- **[Python >=3.7](https://www.python.org/)**
- **[Ansible >=2.9](https://www.ansible.com/)**
- Ansible controller should be a macOS/Linux environment (WSL/Docker can be used on Windows)

### Host Requirements

There are Python and Ansible package requirements need to be installed by running the following command (or equivalent) in the root of this repository:

```
if type poetry &> /dev/null; then poetry install --no-root; else pip3 install -r .config/requirements.txt; fi
ansible-galaxy install requirements.yml
```

#### Easier Method of Installing the Host Requirements

You can also run `bash .config/scripts/start.sh` if you do not mind development dependencies being installed as well. This method will even handle installing Python 3 and Ansible.

### Operating System

**This playbook is built and tested to run on fresh installs of Windows, Mac OS X, Ubuntu, Fedora, Debian, CentOS, and Archlinux**. It may still be possible to run the playbook on your current machine. However, installing the playbook on a fresh install is the only thing we actively support. That said, if you come across an issue with an environment that already has configurations and software present, please do not hesitate to [open an issue](https://gitlab.com/megabyte-labs/gas-stationrepository.location.issue.gitlab).

### Connection

SSH (or WinRM in the case of Windows) and Python should be available on the target systems you would like to provision. If you are attempting to provision a Windows machine, you can ensure that WinRM is enabled and configured so that you can remotely provision the Windows target by running the following command with PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://gitlab.com/megabyte-labs/gas-station/-/raw/master/files/client.ps1'))
```

### MAS on Mac OS X

We use [mas](https://github.com/mas-cli/mas) to install apps from the App Store in some of our roles. Sadly, automatically signing into the App Store is not possible on OS X 10.13+ via mas. This is because [mas no longer supports login functionality on OS X 10.13+](https://github.com/mas-cli/mas/issues/164).

There is another caveat with mas. In order to install an application using mas, the application has to have already been added via the App Store GUI. This means that the first time around you will have to install the apps via the App Store GUI so they are associated with your App Store account.

<a href="#software" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Software

This project breaks down software into a role (found in the subdirectories of the `roles/` folder) if the software requires anything other than being added to the `PATH` variable. Below is a quick description of what each role does. Browsing through this list, along with the conditions laid out in `main.yml`, you will be able to get a better picture of what software will be installed by the default `main.yml` playbook.

role_descriptions

We encourage you to browse through the repositories that are linked to in the table above to learn about the configuration options they support.

### Binaries

A lot of nifty software does not require any configuration other than being added to the `PATH` or being installed with an installer like `brew`. For this kind of software that requires no configuration, we list the software we would like installed by the playbook as a variable in `group_vars/` or `host_vars/` as an array of keys assigned to the `software` variable ([example here](environments/prod/group_vars/desktop/vars.yml)). With those keys, we install the software using the `[professormanhattan.genericinstaller](https://galaxy.ansible.com/professormanhattan/genericinstaller)` role which determines how to install the binaries by looking up the keys against the `software_package` object ([example here](environments/prod/group_vars/all/software.yml)). For your convienience, the software we recommend and install by default is listed below:

binary_var_chart

### NPM Packages

NPM provides a huge catalog of useful CLIs and libraries so we also include a useful and interesting default set of NPM-hosted CLIs for hosts in the `desktop` group ([defined here](environments/prod/group_vars/desktop/npm-packages.yml), for example):

npm_var_chart

### Python Packages

In a similar fashion to the NPM packages, we include a great set of default Python packages that are included by default for the `desktop` group ([defined here](environments/prod/group_vars/desktop/pip-packages.yml)):

pypi_var_chart

### Ruby Gems

A handful of Ruby gems are also installed on targets in the `desktop` group ([defined here](environments/prod/group_vars/desktop/ruby-gems.yml)):

gem_var_chart

### Visual Studio Code Extensions

A considerable amount of effort has gone into researching and finding the "best" VS Code extensions. They are [defined here](environments/prod/group_vars/desktop/vscode-extensions.yml) and Gas Station also installs a good baseline configuration which includes settings for these extensions:

vscode_var_chart

### Chrome Extensions

To reduce the amount of time it takes to configure Chromium-based browsers like Brave, Chromium, and Chrome, we also include the capability of automatically installing Chromium-based browser extensions (via a variable [defined here](environments/prod/group_vars/desktop/chrome-extensions.yml)):

chrome_var_chart

### Homebrew Formulae (macOS and Linux only)

Although most of the `brew` installs are handled by the [Binaries](#binaries) installer, some `brew` packages are also installed using [this configuration](environments/prod/group_vars/desktop/homebrew.yml). The default Homebrew formulae include:

brew_var_chart

### Homebrew Casks (macOS only)

On macOS, some software is installed using Homebrew casks. These include:

cask_var_chart

### Go, Rust, and System-Specific Packages

Go packages, Rust crates, and system-specific packages like `.deb` and `.rpm` bundles are all handled by the `[professormanhattan.genericinstaller](https://galaxy.ansible.com/professormanhattan/genericinstaller)` role described above in the [Binaries](#binaries) section. There are also ways of installing Go and Rust packages directly by using configuration options provided by their corresponding roles outlined in the [Roles](#roles) section.

<a href="#web-applications" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Web Applications

This playbook does a bit more than just install software. It also optionally sets up web applications too. If you choose to deploy the default Gas Station web applications on your network, you should probably do it on a computer/server that has a lot of RAM (e.g. 64GB+).

Although a production environment will always be more stable and performant if it is hosted with a major cloud provider, sometimes it makes more sense to locally host web applications. Some applications have abnormally large RAM requirements that could potentially cost thousands per month to host with a legit cloud provider.

We use Kubernetes as the provider for the majority of the applications. It is a production-grade system and although there is a steeper learning curve it is well worth it. Each application we install is packaged as a Helm chart. All of the data is backed up regularly to an encrypted cloud S3 bucket of your choice.

### Helm Charts

The available Helm charts that this playbook completely handles the set up for are listed below.

helm_var_chart

### Host Applications

By default, on each computer provisioned using the default settings of Gas Station, several apps are installed on each host. Docker Compose is used to manage the deployment. The default apps include:

| App                                                | Description                                                                                                                                           |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **[Authelia](https://www.authelia.com/)**          | An authentication portal that supports SSO and 2FA                                                                                                    |
| **[Homer](https://github.com/bastienwirtz/homer)** | A very simple homepage which is customized by the playbook to automatically include links to the Docker containers you choose to host on the computer |
| **[Portainer](https://www.portainer.io/)**         | A Docker management tool                                                                                                                              |
| **[Serve](https://github.com/vercel/serve)**       | Simple interface for viewing files located or symlinked to in the `/var/www/` folder of the machine                                                   |

You can, of course, disable deploying these apps. However, we include them because they have a small footprint and include useful features. You can also customize the list of apps you wish to include on each host.

#### HTPC

We do not maintain any of the host applications except the ones listed above. However, we do provide the capability of marking a computer being provisioned as an HTPC. Doing this will include a suite of web applications with powerful auto-downloading, organizing, tagging, and media-serving capabilities. Since most people will probably be stepping outside the confines of the law for this, it is not recommended. If you still want to experiment then you can find descriptions of the applications below. The applications are intended to be hosted on a single computer via Docker Compose. The backend for Kodi is included but you should still use the regular installation method for Plex and the front-end of Kodi to view your media collection.

| App                                                                        | Description                                                                      |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **[WireGuard](https://docs.linuxserver.io/images/docker-wireguard)**       | Dedicated VPN for the HTPC applications                                          |
| **[Bazarr](https://docs.linuxserver.io/images/docker-bazarr)**             | Manages and automatically downloads subtitles                                    |
| **[Heimdall](https://docs.linuxserver.io/images/docker-heimdall)**         | Start page for all the HTPC apps                                                 |
| **[Jackett](https://docs.linuxserver.io/images/docker-jackett)**           | Request proxy server for Radarr and Sonarr                                       |
| **[Kodi Headless](https://hub.docker.com/r/linuxserver/kodi-headless)**    | Backend for Kodi                                                                 |
| **[Lidarr](https://docs.linuxserver.io/images/docker-lidarr)**             | Music collection manager that automatically downloads from BitTorrent and Usenet |
| **[NZBGet](https://docs.linuxserver.io/images/docker-nzbget)**             | Usenet downloader                                                                |
| **[Ombi](https://docs.linuxserver.io/images/docker-ombi)**                 | Plex request and user management system                                          |
| **[Organizr](https://docs.linuxserver.io/images/docker-htpcmanager)**      | Front end for HTPC web applications                                              |
| **[Radarr](https://docs.linuxserver.io/images/docker-radarr)**             | Automatic movie downloader                                                       |
| **[Sonarr](https://docs.linuxserver.io/images/docker-sonarr)**             | Automatic TV show downloader                                                     |
| **[Tautulli](https://docs.linuxserver.io/images/docker-tautulli)**         | Metrics and monitoring for Plex                                                  |
| **[Transmission](https://docs.linuxserver.io/images/docker-transmission)** | BitTorrent client                                                                |

<a href="#philosophy" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Philosophy

The philosophy of this project basically boils down to "**_automate everything_**" and include the best development tools that might be useful without over-bloating the machine with services. Automating everything should include tasks like automatically accepting software terms in advance or pre-populating Portainer with certificates of all the Docker hosts you would like to control. One problem we face is that there are so many great tools offered on GitHub. A lot of research has to go into what to include and what to pass on. The decision of whether or not to include a piece of software in the default playbook basically boils down to:

- **Project popularity** - If one project has 10k stars and a similar alternative has 500 stars then 9 times of out 10 the more popular project is selected.
- **Last commit date** - We prefer software that is being actively maintained, for obvious reasons.
- **Cross platform** - Our playbook supports the majority of popular operating systems so we opt for cross-platform software. However, in some cases, we will include software that has limited cross-platform support like Xcode (which is only available on Mac OS X). If a piece of software is too good to pass up, it is added and only installed on the system(s) that support it.
- **Usefulness** - If a tool could potentially improve developer effectiveness then we are more likely to include it.
- **System Impact** - Software that can be run with a small RAM footprint and software that does not need a service to load on boot is much more likely to be included.

One of the goals of this project is to be able to re-provision a network with the click of a button. This might not be feasible since consumer-grade hardware usually does not include features like IPMI (which is a feature included in high-end motherboards that lets you control the power state remotely). However, we aim to reduce the amount of interaction required when re-provisioning an entire network down to the bare minimum. In the worst case scenario, you will have to reformat, reinstall the operating system, and ensure that OpenSSH is running (or WinRM in the case of Windows) on each of the computers in your network. However, the long term goal is to allow the user to reformat and reinstall the operating system used as your Ansible host using an automated USB installer and then automatically re-provision everything else on the network by utilizing IPMI.

You might ask, "But how can I retain application-level configurations?" We currently handle this by:

- Pre-defining dotfiles in a customizable Git repository
- Backing up to encrypted S3 buckets
- Syncing files to private git repositories
- Utilizing tools that synchronize settings like [mackup](https://github.com/lra/mackup) or [macprefs](https://github.com/clintmod/macprefs) in the case of macOS

However, we intentionally keep this synchronization to a minimum (i.e. only back up what is necessary). After all, one of the goals of this project is to be able to regularly flush the bad stuff off a system. By keeping what we back up to a minimum, we reduce the attack surface.

<a href="#architecture" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Architecture

You can find a high-level overview of what each folder and file does in the [ARCHITECTURE.md](docs/ARCHITECTURE.md) file.

<a href="#managing-environments" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Managing Environments

We accomplish managing different environments by symlinking all the folders that should be unique to each network environment (e.g. `host_vars/`, `group_vars/`, `inventories/`, `files/vpn/`, and `files/ssh/`). In the `environments/` folder, you will see multiple folders. In our case, `environments/dev/` contains sensible configurations for testing the playbook and its' roles. The production environment is a seperate git submodule that links to a private git repository that contains our Ansible-vaulted API keys and passwords. When you are ready to set up your production configurations, you can use this method of storing your environment-specific folders in the `environments/` folder as well. But if you are just starting off, you do not have to worry about this since, by default, this playbook is configured to run with the settings included in the `/environments/dev/` folder.

### Switching Between Environments

If you already have the project bootstrapped (i.e. already ran `bash .config/scripts/start.sh`), you can switch environments with an interactive prompt by running:

```shell
task ansible:playbook:environment
```

Alternatively, you can run the following if you would like to bypass the prompt:

```shell
task ansible:playbook:environment -- environmentName
```

<a href="#contributing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/ProfessorManhattan/Gas-Station/issues). If you would like to contribute, please take a look at the [contributing guide](https://github.com/ProfessorManhattan/Gas-Station/blob/master/CONTRIBUTING.md).

<details>
<summary><b>Sponsorship</b></summary>
<br/>
<blockquote>
<br/>
Dear Awesome Person,<br/><br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a title="Support us on Open Collective" href="https://opencollective.com/megabytelabs" target="_blank">
  <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=opencollective&label=OpenCollective&logoColor=white&style=for-the-badge" />
</a>
<a title="Support us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
  <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=for-the-badge" />
</a>
<a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
  <img alt="Patreon" src="https://img.shields.io/badge/Patreon-Support-052d49?logo=patreon&logoColor=white&style=for-the-badge" />
</a>

</details>

<a href="#license" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## License

Copyright © 2020-2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/gas-station/-/blob/master/LICENSE) licensed.
