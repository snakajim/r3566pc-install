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
TARGET_DIR="/mnt/tmp"
PARTISION_ID="p1"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./tmp | ( cd ${TARGET_DIR}; tar xvf -)"

# Partion 2:  +10G -> /var
TARGET_DIR="/mnt/var"
PARTISION_ID="p2"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./var | ( cd ${TARGET_DIR}; tar xvf -)"

# Partion 3:  +10G -> /var
TARGET_DIR="/mnt/usr/local"
PARTISION_ID="p3"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./usr/local | ( cd ${TARGET_DIR}; tar xvf -)"

# Partion 4:  37.3G -> /home
TARGET_DIR="/mnt/home"
PARTISION_ID="p3"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./home | ( cd ${TARGET_DIR}; tar xvf -)"
