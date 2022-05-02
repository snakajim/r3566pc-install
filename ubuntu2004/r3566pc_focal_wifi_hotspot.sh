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
#
# check if wifi HW is available
#
WIFISTATE=`nmcli device status | grep wifi | grep -v wifi-p2p`
if [ ! ${WIFISTATE} == "0" ]; then
  WIFIIF=`echo ${WIFISTATE} | awk '{print $1}'`
  echo "WIFIIF=${WIFIIF} is delected."
else
  echo "WiFi is not detected. Do you have WiFi HW? Please check $> nmcli device status"
  echo "Program exit."
  exit
fi
# ##########################################################
# DHCP server setting, DHCP for $WIFIIF interface only.
# This is still broken, for future study only!
# ##########################################################
sudo apt -y install isc-dhcp-server hostapd
# modify /etc/default/isc-dhcp-server
sudo sed -i -e "s/^#DHCPDv4_CONF=/DHCPDv4_CONF=/" /etc/default/isc-dhcp-server
sudo sed -i -e "s/^INTERFACESv4=\"\"/INTERFACESv4=\"$WIFIIF\"/" /etc/default/isc-dhcp-server
# modify /etc/dhcp/dhcpd.conf 
sudo sed -i -e "s/^option domain-name/###option domain-name/" /etc/dhcp/dhcpd.conf 
sudo sed -i -e "s/^#authoritative;/authoritative;/" /etc/dhcp/dhcpd.conf 
cat << EOL | sudo tee -a /etc/dhcp/dhcpd.conf
subnet 192.168.16.0 netmask 255.255.255.0 {
   range 192.168.16.130 192.168.16.254;
}
EOL
# enable and restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl restart isc-dhcp-server 

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

#
# Install NGINX,ufw and open http server
#
sudo apt install -y nginx ufw
sudo sed -i -e "s#^IPV6=yes#IPV6=no#" /etc/default/ufw
sudo ufw logging off
sudo ufw enable # disable?
sudo ufw allow 'Nginx Full'
sudo ufw status

#
# check if nginx is active. It should be active.
#
ret=`systemctl is-active nginx`
if [ ! $ret == "active" ]; then
  echo "NGINX is not activated. Installation error?"
  echo "Program exit."
  exit
fi
