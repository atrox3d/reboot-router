#!/bin/bash
#########################################################################################
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
. "${HERE}/.setup"												# load modules
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
NAME="$(basename ${BASH_SOURCE[0]})"							# save this script name
#########################################################################################

info "RUN | " "${HERE}"/ssh-server.sh -f "$(basename ${0} .sh).log" reboot now
"${HERE}"/ssh-server.sh -l "$(basename ${0} .sh).log" reboot now
