#!/bin/bash
# r3566pc_bionic_wifi_hotspot.sh
# SYNOPSIS:
# R3566PC Ubuntu 18.04 LTS WiFi hotsopt enablement.
# HOW TO RUN:
#

#
# Remove all past WiFi history, then enable WiFi interface.
#
sudo nmcli radio wifi off
sudo rm -rf /etc/NetworkManager/system-connections/*
sudo nmcli radio wifi on
#
# check if wifi HW is available
#
WIFISTATE=`nmcli device status |  grep wifi`
if [ ! ${WIFISTATE} == "0" ]; then
  WIFIIF=`echo ${WIFISTATE} | awk '{print $1}'`
  echo "WIFIIF=${WIFIIF} is delected."
else
  echo "WiFi is not detected. Do you have WiFi HW? Please check $> nmcli device status"
  echo "Program exit."
  exit
fi
#
# Hotspot enable command example
# $> nmcli dev wifi hotspot ifname wlp4s0 ssid test password "test1234"
#
HSSSID="r3566pchs"
HSPAWD="12345Ok!"
sudo nmcli dev wifi hotspot ifname ${WIFIIF} ssid ${HSSSID} password ${HSPAWD}
nmcli device wifi list
echo "Now you have HOTSpot."
echo "SSID=${HSSSID}"
echo "Password=${HSPAWD}"

#
#
#