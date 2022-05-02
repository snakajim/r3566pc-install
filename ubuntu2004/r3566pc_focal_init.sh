#!/bin/bash
# r3566pc_focal_init.sh
# SYNOPSIS:
# R3566PC Ubuntu 18.04 LTS initialization script.
# HOW TO USE:
#  After booting R3566PC, you are login as firefly.
#  Run this script once.
# HOW TO ACCESS and RUN:
# $> curl https://raw.githubusercontent.com/snakajim/r3566pc-install/main/ubuntu2004/r3566pc_focal_init.sh > r3566pc_focal_init.sh
# $> chmod +x r3566pc_focal_init.sh
# $> ./r3566pc_focal_init.sh
# 
sudo apt -y update && sudo apt -y install nano git
sudo apt-get install -y avahi-daemon
sudo systemctl restart avahi-daemon.service
#
# change /etc/ssh/sshd_config
# to allow root ssh login.
sudo sed -i -e "s/^#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
sudo service sshd restart
#
# change autologin-user in lightdm
#
sudo sed -i -e "s/^autologin-user/#autologin-user/" /etc/lightdm/lightdm.conf.d/20-autologin.conf
#
# change timezone to Asia/Tokyo
#
sudo timedatectl set-timezone Asia/Tokyo
#
# change keyboard layout
#
localectl | grep "X11 Layout" | grep jp
ret=$?
if [ ! $ret == "0" ]; then
  sudo apt -y install nano
  sudo dpkg-reconfigure keyboard-configuration
  sudo reboot
fi
#
# reset Window system(auto logout)
sudo service lightdm restart