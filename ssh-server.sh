#!/bin/bash
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"	# get current path
CONFIG_FILE=${HERE}/private/config

function get_key()
{
	[ $# -ge 2 ] || {
		echo "FATAL | syntax   | getkey key_name file_name [delimiter]"
		echo "FATAL | received | getkey ${@}"
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
			echo "FATAL | getkey | key: '${_key_name}' not found in '${_file_name}' "
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


echo "SERVER     | $SERVER"
echo "USER       | $USER"
echo "PASSWORD   | $PASSWORD"
echo "SSH_OPTIONS| $SSH_OPTIONS"

if [ $# -gt 0 ]
then
	COMMAND="${*}"
	echo "${COMMAND}" \| sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
	echo "${COMMAND}" | sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
else
	echo sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
	sshpass -p "${PASSWORD}" ssh ${SSH_OPTIONS} "${USER}@${SERVER}"
fi



