# This file should run after quickstart.ps1 reboots

ubuntu run "curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/raw/master/scripts/quickstart.sh > quickstart.sh"
ubuntu run "bash quickstart.sh"
