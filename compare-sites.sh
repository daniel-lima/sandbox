#!/bin/bash

#apt-get install imagemagick imagemagick-doc
#apt-get install xvfb
#apt-get install xfonts-base xfonts-75dpi xfonts-100dpi
#apt-get install xdotool 
# apt-get install wmctrl

# firefox -P empty_profile -no-remote

_old_url=$1
_new_url=$2

shift 2
_paths=$*

_width=1280
_height=960

function snap_it() {
    url=$1
    #rm sessionstore.js
    #DISPLAY=:11 xdotool search firefox windowkill
    #DISPLAY=:11 xdotool search firefox windowactivate --sync key --window 0 alt+f4
    #DISPLAY=:11 xdotool search firefox windowactivate --sync key --window 0 alt+f4
    #killall firefox
    DISPLAY=:11 firefox -P empty_profile -no-remote -width ${_width} -height ${_height} -new-window "http://${url}" &
    #DISPLAY=:11 wmctrl -c firefox
    #DISPLAY=:11 firefox -P empty_profile -no-remote -width ${_width} -height ${_height} "http://${url}" &
    #DISPLAY=:11 chromium-browser --user-data-dir=~/x/abc "http://${url}" &
    ff_pid=$!
    sleep 10s
    DISPLAY=:11 import -window root "${url}.png"
    #DISPLAY=:11 wmctrl -c chromium-browser
    #DISPLAY=:11 wmctrl -c firefox
    DISPLAY=:11 xdotool search firefox windowkill

    #killall firefox
    #if [ -n ${ff_pid} ]; then
#	kill ${ff_pid}
 #   fi
}


function snap_all() {
    base_url=$1
    shift
    paths=$*

    mkdir -p ${base_url}

    #DISPLAY=:11 firefox -P empty_profile -no-remote -width ${_width} -height ${_height} -new-window www.google.com &
    ff_pid=$!
    echo "Firefox pid ${ff_pid}"
    sleep 5s

    for path in ${paths}; do
	snap_it "${base_url}/${path}";
    done    

    #if [ -n ${ff_pid} ]; then
#	kill ${ff_pid}
#    fi
}


Xvfb :11 -screen 0 "${_width}x${_height}x24" &
_xvfb_pid=$!
echo "Xvfb pid ${_xvfb_pid}"

snap_all ${_old_url} ${_paths}


kill ${_xvfb_pid}


# http://kb.mozillazine.org/Command_line_arguments#For_Linux_and_Mac_OS_X_users
# http://ivanvillareal.com/linux/xvfb-and-firefox-headles-screenshot-generator/
# http://jerel.co/blog/2010/10/using-firefox-on-a-headless-server-to-make-screenshots-of-websites
# http://askubuntu.com/questions/209517/does-diff-exist-for-images
# http://www.imagemagick.org/script/compare.php
# http://stackoverflow.com/questions/5132749/imagemagick-diff-an-image
# http://www.semicomplete.com/projects/xdotool/#idp24160
# https://groups.google.com/forum/#!topic/xdotool-users/fc5xqdVPDN4
# http://kb.mozillazine.org/Session_Restore#Completely_disabling_session_store
# https://support.mozilla.org/pt-BR/questions/951221
