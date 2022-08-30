#!/bin/bash
#########################################################################################
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
. "${HERE}/.setup"												# load modules
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
NAME="$(basename ${BASH_SOURCE[0]})"							# save this script name
#########################################################################################

LOG_FILE="$(basename ${0} .sh).log"
# info "LOGFILE         | ${HERE}/${LOG_FILE}"
# info "LOGFILE SUMMARY | ${HERE}/${LOG_FILE}.summary"
info "RUN | " "${HERE}"/ssh-server.sh -l "${LOG_FILE}" reboot now |& tee -a  "${HERE}/${LOG_FILE}" |& tee -a "${HERE}/${LOG_FILE}.summary"
#"${HERE}"/ssh-server.sh -l "${LOG_FILE}" reboot now

if [ $? -eq 0 ]
then
	info "STATUS | SUCCESS" |& tee -a "${HERE}/${LOG_FILE}.summary"
else
	info "STATUS | ERROR" |& tee -a "${HERE}/${LOG_FILE}.summary"
fi
