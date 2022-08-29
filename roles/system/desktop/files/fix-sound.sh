#!/bin/bash
# Use this script when the sound shows up as "Dummy Output" in Ubuntu 20.04
# Source: https://www.linuxuprising.com/2018/06/fix-no-sound-dummy-output-issue-in.html
if lsmod | grep -q snd_hda_intel; then
  echo "OK. lsmod contains the snd_hda_intel kernel module."
  if lspci -nnk | grep -A2 Audio | grep "Kernel driver in use: snd_hda_intel"; then
    echo "OK. lspci -nnk also shows kernel driver is in use."
    echo "options snd-hda-intel model=generic" | sudo tee -a /etc/modprobe.d/alsa-base.conf
    echo "OK. Added options for snd-hda-intel to /etc/modprobe.d/alsa-base.conf. REBOOT REQUIRED NOW."
  else
    echo "The snd_hda_intel kernel module is part of the kernel but the snd_hda_intel driver does not appear to be in use"
  fi
else
  echo "Failed. The snd_hda_intel kernel module does not appear to be part of the kernel."
fi
