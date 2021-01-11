#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

progress "Installing mavlink-router master branch"

. config.env

if [ -z "$TELEM_SERIAL_PORT" ]; then
    echo 'TELEM_SERIAL_PORT must be set (e.g. "/dev/ttyS1" or "/dev/ttyMFD1")'
    exit 1
fi

set -e
set -x

adduser $NORMAL_USER dialout

apt install autoconf automake libtool -y

sudo -u $NORMAL_USER -H bash <<EOF
set -e
set -x

. config.env

pushd ~/GitHub
 rm -rf mavlink-router
 git clone --recurse-submodules https://github.com/01org/mavlink-router
 pushd mavlink-router
  git submodule update --init --recursive
  ./autogen.sh && ./configure CFLAGS='-g -O2' \
            --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib64 \
            --prefix=/usr
  time make
  sudo make install
 popd
popd

EOF

progress "Setting up mavlink-router service"

rm -rf /etc/mavlink-router
mkdir /etc/mavlink-router

cp mavlink-router.conf /etc/mavlink-router/main.conf
perl -pe 's%/dev/ttyUSB0%$TELEM_SERIAL_PORT%' -i /etc/mavlink-router/main.conf
systemctl enable mavlink-router.service
systemctl start mavlink-router.service
