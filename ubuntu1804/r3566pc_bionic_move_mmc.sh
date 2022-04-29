#!/bin/bash
# r3566pc_bionic_move_mmc.sh
#
apt -y update && apt -y upgrade
sudo dpkg-reconfigure keyboard-configuration

#
# mount MMC and copy
#
sudo fdisk /dev/mmcblk0
sudo reboot

# Partion 1:  +1G -> /tmp
# Partion 2: +10G -> /var
# Partion 3: +10G -> /usr/local
# Partion 4: 37.3G-> /home
sudo mkfs.ext4 /dev/mmcblk0p1
sudo mkfs.ext4 /dev/mmcblk0p2
sudo mkfs.ext4 /dev/mmcblk0p3
sudo mkfs.ext4 /dev/mmcblk0p4

#
# mount, copy and set /etc/fstab
#

# Partion 1:  +1G -> /tmp

