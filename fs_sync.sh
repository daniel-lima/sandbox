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


function run() {
    local _local_path=$1
    local _remote_destiny=$2

    local _events="CREATE,DELETE,MODIFY,MOVED_FROM,MOVED_TO"
    
    echo "inotifywait -e '${_events}' -m -r --format '%:e %f' '${_local_path}' --excludei '\.git' --excludei '\.svn' --excludei '.\+~'"
    inotifywait -e "${_events}" -m -r --format '%:e %f' "${_local_path}" --excludei '\.git' --excludei '\.svn' --excludei '.\+~' | (
	local _waiting="";
	while true; do
	    local _line="";
	    read -t 1 _line;
	    if test -z "${_line}"; then
		if test ! -z "${_waiting}"; then
                    echo "CHANGE";
                    _waiting="";
                    #rsync --update --archive --links --safe-links --verbose --compress --recursive --exclude '\.git' --exclude '\.svn' --exclude '.\+~' "${_local_path}/*" "${_remote_destiny}"
		fi;
	    else
		_waiting=1;
	    fi;
	    done)
    


}


install_inotifywait
install_rsync
run $*