#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

progress "Part 3 of apsync installation"

pushd /home/$NORMAL_USER/GitHub/companion/Up_Squared/Ubuntu

progress "removing modem manager"
apt remove modemmanager

progress "installing avahi-daemon"
apt install avahi-daemon -y

# install packages common to all
pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu
time ./install_packages.sh
popd

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu
time ./install_niceties
popd

progress "Success! Finished part 3"

