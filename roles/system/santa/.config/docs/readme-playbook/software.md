## Software

This project breaks down software into a role (found in the subdirectories of the `roles/` folder) if the software requires anything other than being added to the `PATH` variable. Below is a quick description of what each role does. Browsing through this list, along with the conditions laid out in `main.yml`, you will be able to get a better picture of what software will be installed by the default `main.yml` playbook.

{{ role_descriptions }}

We encourage you to browse through the repositories that are linked to in the table above to learn about the configuration options they support.

### Binaries

A lot of nifty software does not require any configuration other than being added to the `PATH` or being installed with an installer like `brew`. For this kind of software that requires no configuration, we list the software we would like installed by the playbook as a variable in `group_vars/` or `host_vars/` as an array of keys assigned to the `software` variable ([example here](environments/prod/group_vars/desktop/vars.yml)). With those keys, we install the software using the `[professormanhattan.genericinstaller](https://galaxy.ansible.com/professormanhattan/genericinstaller)` role which determines how to install the binaries by looking up the keys against the `software_package` object ([example here](environments/prod/group_vars/all/software.yml)). For your convienience, the software we recommend and install by default is listed below:

{{ binary_var_chart }}

### NPM Packages

NPM provides a huge catalog of useful CLIs and libraries so we also include a useful and interesting default set of NPM-hosted CLIs for hosts in the `desktop` group ([defined here](environments/prod/group_vars/desktop/npm-packages.yml), for example):

{{ npm_var_chart }}

### Python Packages

In a similar fashion to the NPM packages, we include a great set of default Python packages that are included by default for the `desktop` group ([defined here](environments/prod/group_vars/desktop/pip-packages.yml)):

{{ pypi_var_chart }}

### Ruby Gems

A handful of Ruby gems are also installed on targets in the `desktop` group ([defined here](environments/prod/group_vars/desktop/ruby-gems.yml)):

{{ gem_var_chart }}

### Visual Studio Code Extensions

A considerable amount of effort has gone into researching and finding the "best" VS Code extensions. They are [defined here](environments/prod/group_vars/desktop/vscode-extensions.yml) and Gas Station also installs a good baseline configuration which includes settings for these extensions:

{{ vscode_var_chart }}

### Chrome Extensions

To reduce the amount of time it takes to configure Chromium-based browsers like Brave, Chromium, and Chrome, we also include the capability of automatically installing Chromium-based browser extensions (via a variable [defined here](environments/prod/group_vars/desktop/chrome-extensions.yml)):

{{ chrome_var_chart }}

### Homebrew Formulae (macOS and Linux only)

Although most of the `brew` installs are handled by the [Binaries](#binaries) installer, some `brew` packages are also installed using [this configuration](environments/prod/group_vars/desktop/homebrew.yml). The default Homebrew formulae include:

{{ brew_var_chart }}

### Homebrew Casks (macOS only)

On macOS, some software is installed using Homebrew casks. These include:

{{ cask_var_chart }}

### Go, Rust, and System-Specific Packages

Go packages, Rust crates, and system-specific packages like `.deb` and `.rpm` bundles are all handled by the `[professormanhattan.genericinstaller](https://galaxy.ansible.com/professormanhattan/genericinstaller)` role described above in the [Binaries](#binaries) section. There are also ways of installing Go and Rust packages directly by using configuration options provided by their corresponding roles outlined in the [Roles](#roles) section.
