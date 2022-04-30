#!/bin/bash
# r3566pc_bionic_init.sh
# SYNOPSIS:
# R3566PC Ubuntu 18.04 LTS initialization script.
# HOW TO RUN:
#  After booting R3566PC, you are login as firefly.
#  RUn this script once.
#
sudo apt -y update && sudo apt -y upgrade
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
sudo service lightdm restart
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
# reboot
sudo reboot