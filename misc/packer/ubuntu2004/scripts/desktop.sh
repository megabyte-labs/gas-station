#!/bin/sh -eux

echo "Install the tasksel manager utility"
sudo apt-get install tasksel -y

echo "Install Desktop environment"
sudo apt-get install ubuntu-desktop -y

echo "Rebooting"
sudo reboot