#!/bin/bash
#
# Author: Daniel Henrique Alves Lima


function install_inotifywait() {
    if ! which inotifywait; then
	if which apt-get; then
	    echo 'Installing inotity'
	    sudo apt-get -y install inotify-tools
	fi
    fi
}


function install_rsync() {
    if ! which rsync; then
	if which apt-get; then
	    echo 'Installing rsync'
	    sudo apt-get -y install rsync
	fi
    fi
}

function install_sshpass() {
    if ! which sshpass; then
	if which apt-get; then
	    echo 'Installing sshpass'
	    sudo apt-get -y install sshpass
	fi
    fi
}


function run() {
    if [ $# -ne 2 ]; then
	echo "Usage: $0 local_path remote_user@remote_host:remote_path"
	exit 1
    fi

    local _local_path=$1
    local _remote_destiny=$2
    local _rsync_extra_arg=


    if [ -n "${SSHPASS}" ]; then
	echo "It will use SSHPASS environment variable"
	install_sshpass

	local _remote_user=`echo "${_remote_destiny}" | cut -f1 -d'@'`
	_remote_destiny=`echo "${_remote_destiny}" | cut -f2 -d'@'`
	_rsync_extra_arg="--rsh='sshpass -e ssh -l ${_remote_user}'"
    fi

    _rsync_cmd="rsync --update --archive --links --safe-links --verbose --progress --recursive --exclude '\.git' --exclude '\.svn' --exclude '.\+~' ${_rsync_extra_arg} '${_local_path}'/* '${_remote_destiny}'"

    # http://stackoverflow.com/questions/20370566/inotify-and-rsync-on-large-number-of-files
    local _events="CREATE,DELETE,MODIFY,MOVED_FROM,MOVED_TO"
    
    #echo "inotifywait -e '${_events}' -m -r --format '%:e %f' '${_local_path}' --excludei '\.git' --excludei '\.svn' --excludei '.\+~'"
    inotifywait --event "${_events}"  --monitor --recursive --format '%:e %f' "${_local_path}" --excludei '\.git' --excludei '\.svn' --excludei '.\+~' | (
	local _reading_events="";
	while true; do
	    local _line=;
	    read -t 1 _line;
	    if test -z "${_line}"; then
		if test -n "${_reading_events}"; then
                    echo "CHANGE";
                    _reading_events=;
		    #echo "${_rsync_cmd}"
		    eval "${_rsync_cmd}"
		fi;
	    else
		# It will read all events before trying to rsync anything
		_reading_events=1;
	    fi;
	    done)
}


install_inotifywait
install_rsync
run $*