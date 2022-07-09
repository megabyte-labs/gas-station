# This file should run after quickstart.ps1 reboots

# @description Ensure WSL2 is being used
wsl --set-default-version 2

# @description The following line triggers the WSL installation / account creation process if the environment
#   does not already exist. It echoes the message if the environment is already prepped.
ubuntu run "echo 'Ubuntu WSL is already installed'"

# @description Download the quickstart.sh script
ubuntu run "curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/raw/master/scripts/quickstart.sh > quickstart.sh"

# @description Run the quickstart.sh script with bash
ubuntu run "sudo apt-get update && sudo apt-get upgrade -y && bash quickstart.sh"
