#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

pushd /home/$NORMAL_USER/GitHub/companion/Up_Squared/Ubuntu
time ./setup_mavlink_router.sh
popd

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu/dflogger/
time ./install_dflogger # ~210s
popd

time apt-get install -y libxml2-dev libxslt1.1 libxslt1-dev

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu/pymavlink/
time ./install_pymavlink # new version required for apweb #1m
popd

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu/apweb
time ./install_apweb # 2m
popd

progress "Success! Finished part 4"
