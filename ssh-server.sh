#!/bin/bash
#########################################################################################
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
. "${HERE}/.setup"												# load modules
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
NAME="$(basename ${BASH_SOURCE[0]})"							# save this script name
#########################################################################################
CONFIG_FILE=${HERE}/private/config

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


if [ -f "${CONFIG_FILE}" ]
then
	SERVER="$(get_key server "${CONFIG_FILE}")"
	USER="$(get_key user "${CONFIG_FILE}")"
	PASSWORD="$(get_key password "${CONFIG_FILE}")"
	SSH_OPTIONS="$(get_key ssh-options "${CONFIG_FILE}" = OPTIONAL)"
else
	echo "FATAL | file not found: ${CONFIG_FILE}"
	exit 255
fi


info "SERVER      | ${SERVER}"
info "USER        | ${USER}"
info "PASSWORD    | ${PASSWORD}" |& sed s/"${PASSWORD}"/********/
info "SSH_OPTIONS | ${SSH_OPTIONS}"

if [ $# -gt 0 ]
then
	COMMAND="${*}"
	info "RUN | " "${COMMAND}" \| sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"\
	|& sed s/"${PASSWORD}"/********/
	# echo "${COMMAND}" | sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
else
	info "RUN | " sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"\
	|& sed s/"${PASSWORD}"/********/
	# sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
fi



