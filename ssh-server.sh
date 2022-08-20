#!/bin/bash
#########################################################################################
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
. "${HERE}/.setup"												# load modules
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
NAME="$(basename ${BASH_SOURCE[0]})"							# save this script name
#########################################################################################

function get_key()
{
	[ $# -ge 2 ] || {
		fatal "syntax | getkey key_name file_name [delimiter]"
		fatal "syntax | received | getkey ${@}"
		exit 255
	}
	local _key_name="$1"
	local _file_name="$2"
	local _delim="${3:-=}"
	# echo "\$(grep -i "^${_key_name}=" "${_file_name}" | cut -d "${_delim}" -f2-)"
	if _line="$(grep -i "^${_key_name}=" "${_file_name}")"
	then
		local _value="$(echo "${_line}" | cut -d "${_delim}" -f2-)"
		echo "$_value"
	else
		if [ "${3^^}" != OPTIONAL -o "${4^^}" != OPTIONAL ]
		then
			fatal "getkey | key: '${_key_name}' not found in '${_file_name}' "
			exit 255
		fi
	fi
}

CONFIG_PATH=${HERE}/private
CONFIG_FILE=config
unset LOG_FILE
while getopts "c:p:l:" OPT
do
	case "$OPT" in
		c)
			CONFIG_FILE="${OPTARG}"
			info CONFIG_FILE "${CONFIG_FILE}"
		;;
		p)
			CONFIG_PATH="${OPTARG}"
			info CONFIG_PATH "${CONFIG_PATH}"
		;;
		l)
			LOG_FILE="${OPTARG}"
			info LOG_FILE "${LOG_FILE}"
		;;
	esac
done
shift "$((OPTIND-1))"

if [ "${LOG_FILE:-nologfile}" != nologfile ]
then
	LOG_FILE="${HERE}/$(basename "${LOG_FILE}")"
	info LOG_FILE "${LOG_FILE}"
	LOG_TO_FILE=true
else
	LOG_FILE=/dev/null
	LOG_TO_FILE=false
fi

CONFIG_FILE_PATH="${CONFIG_PATH}/${CONFIG_FILE}"
info CONFIG_FILE_PATH "${CONFIG_FILE_PATH}" | tee -a "${LOG_FILE}"
if [ -f "${CONFIG_FILE_PATH}" ]
then
	SERVER="$(get_key server "${CONFIG_FILE_PATH}")"
	USER="$(get_key user "${CONFIG_FILE_PATH}")"
	PASSWORD="$(get_key password "${CONFIG_FILE_PATH}")"
	SSH_OPTIONS="$(get_key ssh-options "${CONFIG_FILE_PATH}" = OPTIONAL)"
else
	echo "FATAL | file not found: ${CONFIG_FILE_PATH}"
	exit 255
fi

{
	info "SERVER      | ${SERVER}"
	info "USER        | ${USER}"
	info "PASSWORD    | ${PASSWORD}"
	info "SSH_OPTIONS | ${SSH_OPTIONS}"

	if [ $# -gt 0 ]
	then
		COMMAND="${*}"
		info "RUN | " "${COMMAND}" \| sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
		echo "${COMMAND}" | sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
	else
		info "RUN | " sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
		sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
	fi
} |& tee >(sed s/${PASSWORD}/*******/ >> "${LOG_FILE}") 


