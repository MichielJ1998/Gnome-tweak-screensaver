#!/bin/bash

# variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

todo=$DIR/ownFiles/todo.conkyrc
conkyFiles=$(ls -d $DIR/ownFiles/*.conkyrc)
transparentView=$DIR/.transparent_overlay.conkyrc
scrnshot=/dev/shm/scrnshot.jpg
blurredScrnshot=/dev/shm/blurred_scrnshot.jpg



# startStopContent needs two arguments: STOP/CONT and a process keyword
# 	STOP will pause the given process
# 	CONT will resume the given process
# All the processes related to the given process keyword are paused or resumed.
function startStopContent {
	ps ax | grep $2 | grep -v grep | while read -r line; do
		tmp=$(echo $line | awk '{print $(1)}')
		kill -$1 $tmp
	done
}

function pauseVMs {
	# $vm will contain the name of a running vm 
	VBoxManage list runningvms | sed -e 's/"\(.*\)".*/\1/' | while read -r vm; do 
		VBoxManage controlvm "$vm" pause # pause the $vm
	done
}

# 	stopContents will pause the list of processes
function stopContents {
	startStopContent STOP firefox
	startStopContent STOP mailspring
	startStopContent STOP nautilus
	pauseVMs
}


function to_desktop {
	$DIR/resetScript.sh
	rm $scrnshot $blurredScrnshot
}

filter=Gaussian

# take a screenshot of the current screen 
function scrnshot {
	#scrot -z $scrnshot
	import -silent -quiet -window root -filter $filter -resize 25% $scrnshot
}

# blur the file in $scrnshot
function blurScrnshot {
	# add color and blur
	# this one below is less readable but faster
	# 	it writes temporary convert of blur to ram in small byte 
	#	sequence in stead of saving the file
	convert $scrnshot -write mpr:XY +delete \
	  \( mpr:XY -fill "#2e3847" -colorize 60 -filter $filter -blur 0x2 -write mpr:XY2 \) \
	  \( mpr:XY2  -filter $filter -resize 400% +write $blurredScrnshot \) 
	#null:
	# this one is slower, but still quiet fast 
	# convert $scrnshot -fill "#2e3847" -colorize 50 -filter $filter -blur 0x4 $blurredScrnshot
	# convert $blurredScrnshot -filter $filter -resize 200% $blurredScrnshot
}


function to_foreground {
	# Pause the list of processes
	stopContents

	# call screenshot, then do some other stuf
	scrnshot & 
	scrnshot_pid=$!

	for file in $conkyFiles
	do 
		sed -u -i "s/own_window_type = 'desktop'/own_window_type = 'dock'/g" "$file"
	done

	# change update interval of todo widget	
	sed -u -i "s/update_interval = 10/update_interval = 7200/g" $todo
	
	wait $scrnshot_pid
	# blur the screenshot
	blurScrnshot 

	# kill all conky processes
	killall conky
	
	# add the tmp transparent widget
	# conky -q -c $transparentView &

	# sleep 0.4
	# restart conky todo and systemoverview widgets
	restart_conky
	
	# disable mouses with id 10 and 17
	xinput disable 10
	xinput disable 17
	
	# disable the autolocker
	killall xautolock
	
	# start unclutter in timeout seconds
	#	unclutter makes cursor invisible
	unclutter --timeout 0.1 &
}

function restart_conky {
	conky -q -c $transparentView
	for file in $conkyFiles
	do
		conky -q -c $file
	done

	# conky -q -c $sysOverview
	# sleep 0.2  # this sleep makes sure that both widgets appear almost at the same time
	# conky -q -c $todo
	# conky -q -c $devicesView

}

# toggle the change
#	if currently on desktop, change to foreground (dock)
#	if currently on foreground, change to desktop
function toggle {

	# if running in fullscreen, do nothing but sending a notification
	root_geo="$(xwininfo -root | grep geometry)"
	currWinGeo="$(xwininfo -id $(xdotool getactivewindow) | grep geometry)"
	if [ "$currWinGeo" = "$root_geo" ] ; then
		notify-send "The custom screensaver cannot be activated" "The custom screensaver cannot be activated, due to an application that is running in fullscreen." &
		to_desktop
	else
		# if normal is empty => currently on desktop
		dock=$(cat $sysOverview | grep "own_window_type = 'dock'")
		if [ "$dock" != "" ]; then
			to_desktop
		else
			to_foreground
		fi
	fi


}

# toggle screensaver on
if [[ "$1" = "on" ]]; then
	# if running in fullscreen, do nothing but sending a notification
	# THIS IS CHECKED BY EXTENSION.JS
	# root_geo="$(xwininfo -root | grep geometry)"
	# currWinGeo="$(xwininfo -id $(xdotool getactivewindow) | grep geometry)"
	# if [ "$currWinGeo" = "$root_geo" ] ; then
	# 	notify-send -u critical "The custom screensaver cannot be activated" "The custom screensaver cannot be activated, due to an application that is running in fullscreen."
	# else
	# 	to_foreground
	# fi
	to_foreground
	
# toggle screensaver off
elif [[ "$1" = "off" ]]; then
	to_desktop
# just toggle and see what the current state is
else
	exit
fi
exit
