#!/bin/bash
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path

"${HERE}"/ssh-server.sh reboot now
