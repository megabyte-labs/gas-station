#!/usr/bin/env bash

sudo apt-get update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common sshpass wget openssl git

useradd -m -p "$(openssl passwd -1 password)" --groups sudo gitlab
su -s /bin/bash gitlab
find . -print0 | xargs -0 sudo chown "$USER":"$USER"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install -y docker-ce
sudo usermod -aG docker "$USER"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
source "$HOME/.profile"

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
echo ". $HOME/.asdf/asdf.sh" > ~/.profile
. "$HOME/.asdf/asdf.sh"

sudo apt-get install -y curl dirmngr gpg gawk
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
asdf plugin add python
asdf install python latest
asdf global python latest

asdf plugin add poetry
asdf install poetry latest
asdf global poetry latest
pip install cleo tomlkit poetry.core requests cachecontrol cachy html5lib pkginfo virtualenv lockfile
