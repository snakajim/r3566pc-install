#!/bin/bash
# r3566pc_bionic_init.sh
# SYNOPSIS:
# R3566PC Ubuntu 18.04 LTS initialization script.
# HOW TO RUN:
# 
sudo apt -y update && sudo apt -y upgrade
sudo apt-get install avahi-daemon
sudo systemctl restart avahi-daemon.service

#