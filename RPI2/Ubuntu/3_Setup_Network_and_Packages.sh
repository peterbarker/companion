#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

progress "Part 3 of apsync installation"

pushd /home/$NORMAL_USER/GitHub/companion/RPI2/Ubuntu

progress "removing modem manager"
apt remove modemmanager

progress "removing cloud-init"
apt remove cloud-init

tput setaf 3
echo "installing avahi-daemon"
tput sgr0
apt install avahi-daemon -y

# install packages common to all
pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu
time ./install_packages.sh
popd

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu
time ./install_niceties
popd

# setup wifi access point
time sudo -E ./install_wifi_access_point.sh # 20s

tput setaf 2
echo "Success! Finished part 3"
tput sgr0

