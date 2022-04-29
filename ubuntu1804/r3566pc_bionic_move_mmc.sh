#!/bin/bash
# r3566pc_bionic_move_mmc.sh
#
sudo apt -y update
localectl | grep pc105
ret=$?
if [ ! $ret == "0" ]; then
  sudo dpkg-reconfigure keyboard-configuration
  sudo reboot
fi

#
# mount MMC and copy
#
sudo fdisk /dev/mmcblk0
#sudo reboot

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
sudo cp /etc/fstab /etc/fstab.back
sudo cp /etc/fstab /etc/fstab.new

# Partion 1:  +1G -> /tmp
TARGET_DIR="/mnt/tmp"
PARTISION_ID="p1"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./tmp | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | sudo tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR} ext3  defaults  1  3
EOF
sudo umount ${TARGET_DIR}

# Partion 2:  +10G -> /var
TARGET_DIR="/mnt/var"
PARTISION_ID="p2"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./var | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | sudo tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR} ext3  defaults  1  3
EOF
sudo umount ${TARGET_DIR}

# Partion 3:  +10G -> /usr/local
TARGET_DIR="/mnt/usr/local"
PARTISION_ID="p3"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./usr/local | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | sudo tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR} ext3  defaults  1  3
EOF
sudo umount ${TARGET_DIR}

# Partion 4:  37.3G -> /home
TARGET_DIR="/mnt/home"
PARTISION_ID="p4"
sudo mkdir -p ${TARGET_DIR} && sudo mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd / && sudo sh -c "tar cf - ./home | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | sudo tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR} ext3  defaults  1  3
EOF
sudo umount ${TARGET_DIR}

#
echo ""
echo "#########################"
cat /etc/fstab.new
read -p "Overwrite /etc/fstab,Ok?[Enter]"
sudo cp /etc/fstab.new /etc/fstab
sudo mount -a
read -p "reboot,Ok?[Enter]"
sudo reboot