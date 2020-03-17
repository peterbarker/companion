#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

apt-get install -y python-pip

# install packages common to all
../../Common/Ubuntu/install_packages.sh
