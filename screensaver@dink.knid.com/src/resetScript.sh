#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# variables
todo=$DIR/ownFiles/todo.conkyrc
conkyFiles=$(ls -d $DIR/ownFiles/*.conkyrc)
transparentView=$DIR/.transparent_overlay.conkyrc
scrnshot=/dev/shm/scrnshot.jpg
blurredScrnshot=/dev/shm/blurred_scrnshot.jpg

# startStopContent needs one argument: CONT/STOP and a process keyword
# All the processes related to the given process keyword are resumed.
function startStopContent {
	ps ax | grep $2 | grep -v grep | while read -r line; do
		tmp=$(echo $line | awk '{print $(1)}')
		kill -$1 $tmp
	done
}

# startStopContents needs no arguments
function startStopContents {
	startStopContent CONT firefox
	startStopContent CONT mailspring
	startStopContent CONT nautilus
	resumeVMs
	killall convert
	killall conky
}

function restartConky {
	# if needed reset the dock to desktop
	for file in $conkyFiles
	do 
		sed -u -i "s/own_window_type = 'dock'/own_window_type = 'desktop'/g" "$file"
	done
	sed -i "s/update_interval = 7200/update_interval = 10/g" $todo
	for file in $conkyFiles
	do
		conky -p 1 -q -c $file&
	done
}

function resetDisabledMouses {
	killall unclutter
	xinput enable 10
	xinput enable 17
}

# function resetAutolock {
# 	killall xautolock
# 	xautolock -locker "$DIR/toggle_above_below.sh" -time 1 -corners 0-0- &
# 	xautolock -unlocknow
# }

function resumeVMs {
	# $vm will contain the name of a running vm 
	VBoxManage list runningvms | sed -e 's/"\(.*\)".*/\1/' | while read -r vm; do 
		VBoxManage controlvm "$vm" resume # pause the $vm
	done
}


startStopContents
resetDisabledMouses
restartConky
# resetAutolock

exit
