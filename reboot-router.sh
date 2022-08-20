#!/bin/bash
#########################################################################################
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
. "${HERE}/.setup"												# load modules
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
NAME="$(basename ${BASH_SOURCE[0]})"							# save this script name
#########################################################################################
LOG_FILE="$(basename ${0} .sh).log"
info "RUN | " "${HERE}"/ssh-server.sh -f "${LOG_FILE}" reboot now | tee -a  "${LOG_FILE}" 
"${HERE}"/ssh-server.sh -l "${LOG_FILE}" reboot now
