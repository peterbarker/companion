#!/bin/bash

set -e
set -x

. config.env

pushd ../../Common/Ubuntu/mavproxy
 ./setup_mavproxy.sh
popd

progress "Success! Finished part 5"
