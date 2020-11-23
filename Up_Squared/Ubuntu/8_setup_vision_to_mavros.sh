#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

pushd /home/$NORMAL_USER/GitHub/companion/Common/Ubuntu/vision_to_mavros
time ./install_vision_to_mavros.sh
popd

if [ $SETUP_DEPTH_CAMERA -eq 1 ]; then
   progress 'Success! Finished part 8: installing vision_to_mavros Pose and Depth Scripts'
else
   progress 'Success! Finished part 8: installing vision_to_mavros Pose Script'
fi
