#!/bin/bash
# r3566pc_bionic_move_mmc.sh
#

WHOAMI=`whoami`

if [ ! $WHOAMI == "root" ]; then
  echo "This program should be run in root. Please login as root and try again."
  echo "Program exit."
  exit
fi

#
# mount MMC and copy
#
fdisk /dev/mmcblk0
#reboot

# Partion 1:  +1G -> /tmp
# Partion 2: +10G -> /var
# Partion 3: +10G -> /usr
# Partion 4: 37.3G-> /home
mkfs.ext4 /dev/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p2
mkfs.ext4 /dev/mmcblk0p3
mkfs.ext4 /dev/mmcblk0p4

#
# mount, copy and set /etc/fstab
#
cp /etc/fstab /etc/fstab.back
cp /etc/fstab /etc/fstab.new

# Partion 1:  +1G -> /tmp
TARGET_DIR="/mnt/tmp"
PARTISION_ID="p1"
umount ${TARGET_DIR} && rm -rf ${TARGET_DIR}
mkdir -p ${TARGET_DIR} && mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd /tmp && sh -c "tar cf - . | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR} ext4  defaults  1  3
EOF
umount ${TARGET_DIR}
rm -rf ${TARGET_DIR}

# Partion 2:  +10G -> /var
TARGET_DIR="/mnt/var"
PARTISION_ID="p2"
umount ${TARGET_DIR} && rm -rf ${TARGET_DIR}
mkdir -p ${TARGET_DIR} && mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd /var && sh -c "tar cf - . | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR}  ext4 defaults 1  3
EOF
umount ${TARGET_DIR}
rm -rf ${TARGET_DIR}

# Partion 3:  +10G -> /usr
TARGET_DIR="/mnt/usr"
PARTISION_ID="p3"
umount ${TARGET_DIR} && rm -rf ${TARGET_DIR}
mkdir -p ${TARGET_DIR} && mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd /usr && sh -c "tar cf - . | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR}  ext4  defaults  1 3
EOF
umount ${TARGET_DIR}
rm -rf ${TARGET_DIR}

# Partion 4:  37.3G -> /home
TARGET_DIR="/mnt/home"
PARTISION_ID="p4"
umount ${TARGET_DIR} && rm -rf ${TARGET_DIR}
mkdir -p ${TARGET_DIR} && mount -t ext4 -o defaults /dev/mmcblk0${PARTISION_ID} ${TARGET_DIR}
cd /home && sh -c "tar cf - . | ( cd ${TARGET_DIR}; tar xvf -)"
MOUNT_DIR=`echo ${TARGET_DIR} | sed "s#^/mnt##"`
cat << EOF | tee -a /etc/fstab.new
/dev/mmcblk0${PARTISION_ID} ${MOUNT_DIR}  ext4  defaults  1 3
EOF
umount ${TARGET_DIR}
rm -rf ${TARGET_DIR}

#
echo ""
echo "#########################"
cat /etc/fstab.new
read -p "Overwrite /etc/fstab,Ok?[Enter]"
cp /etc/fstab.new /etc/fstab
mount -a
echo "Make sure you don't have error or warniig in mount."
read -p "If no error, reboot. Ok?[Enter]"
reboot