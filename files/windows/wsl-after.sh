#!/bin/bash
cd ~
mkdir .ssh
cp -rf /mnt/c/Users/Hawkwood/.ssh ~/.ssh
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa_local
chmod 644 ~/.ssh/id_rsa_local.pub
chmod 600 ~/.ssh/id_rsa_web
chmod 644 ~/.ssh/id_rsa_web.pub
