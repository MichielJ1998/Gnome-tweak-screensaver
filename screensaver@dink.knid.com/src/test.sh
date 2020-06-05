#!/bin/bash

conkyDir=/home/michiel/.conky
extension_file=$HOME/.config/argos/lock.2r.sh
status=$1

# if no argument was given, then the process was triggered by the shortkey
#	toggle screensaver and make sure that the icons are alright
if [[ "$status" != "" ]]; then
	if [[ "$status" = "0" ]]; then
		sed -i "s/status=0/status=1/g" $extension_file
		sed -i "s/-unlocked-/-locked-/g" $extension_file
		notify-send "0"
	else
		sed -i "s/status=1/status=0/g" $extension_file
		sed -i "s/-locked-/-unlocked-/g" $extension_file
		notify-send "1"
	fi
else
	notify-send "shortkey was pressed"
fi


exit