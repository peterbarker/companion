#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu/uhubctl
time ./install_uhubctl.sh
popd

progress "Success! Finished part 6"