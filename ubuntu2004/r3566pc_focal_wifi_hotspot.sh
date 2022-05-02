#!/bin/bash
# r3566pc_focal_wifi_hotspot.sh
# SYNOPSIS:
# R3566PC Ubuntu 20.04 LTS WiFi hotsopt enablement.
# HOW TO RUN:
# $> curl https://raw.githubusercontent.com/snakajim/r3566pc-install/main/ubuntu2004/r3566pc_focal_wifi_hotspot.sh > r3566pc_focal_wifi_hotspot.sh
# $> chmod +x r3566pc_focal_wifi_hotspot.sh
# $> ./r3566pc_focal_wifi_hotspot.sh

#
# Remove all past WiFi history, then enable WiFi interface.
#
sudo nmcli radio wifi off
sudo rm -rf /etc/NetworkManager/system-connections/*

# ####################################################################
# Hotspot enable command example by NetManager nmcli.
# $> nmcli dev wifi hotspot ifname wlp4s0 ssid test password "test1234"
# ####################################################################
sudo nmcli radio wifi on
HSSSID="r3566pchs"
HSPAWD="12345Ok!"
WIFISTATE=`nmcli device status | grep wifi | grep -v wifi-p2p`
WIFIIF=`echo ${WIFISTATE} | awk '{print $1}'`
nmcli device show ${WIFIIF}
sudo nmcli dev wifi hotspot ifname ${WIFIIF} ssid ${HSSSID} password ${HSPAWD}
nmcli device wifi list
echo "Now you have HOTSpot."
echo "SSID=${HSSSID}"
echo "Password=${HSPAWD}"
sudo nmcli dev wifi show-password
read -p "Please use this QR. Go to Next?[Enter]"
# change Hotspot autoconnect=true for next login.
# https://people.freedesktop.org/~lkundrak/nm-docs/nm-settings.html
sudo sed -i -e "s/^autoconnect=false/autoconnect=true/" /etc/NetworkManager/system-connections/Hotspot.nmconnection
#
# check if nginx is active. It should be active.
#
ret=`systemctl is-active nginx`
if [ ! $ret == "active" ]; then
  echo "NGINX is not activated. Installation error?"
  echo "Program exit."
  exit
else
  echo "NGINX is activated."
  echo "Please visit http://`hostname`.local to access."
fi
