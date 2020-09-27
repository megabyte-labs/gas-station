#!/bin/sh
# cat freebsd-mount-drive.sh | ssh admin@pfSense 'sh -'
geom disk list
read -p "Using the list above, enter the name of the hard drive you would like to mount: "  harddrive
mkdir /mnt/$harddrive
mount /dev/$harddrive /mnt/$harddrive
echo "/dev/$harddrive /mnt/$harddrive ufs rw 2 2" >> /etc/fstab