#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

pushd /home/$NORMAL_USER/GitHub/companion/Up_Squared/Ubuntu

progress "Running Scripts"

progress "Setting Hostname to apsync"
./set_hostname.sh   # reset the machine's hostname

progress "Removing unused packages"
apt autoremove -y # avoid repeated no-longer-required annoyance

apt-get remove -y unattended-upgrades

progress "Setting up rc.local"
./ensure_rc_local.sh

# progress "Disabling TTY console on serial port"
# ./disable_console.sh

progress "Success! Finished part 2"

progress "Reboot to check changes"
