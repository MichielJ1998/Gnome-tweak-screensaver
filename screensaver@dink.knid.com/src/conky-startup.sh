#!/bin/bash

# todo=/home/michiel/.local/share/gnome-shell/extensions/screensaver@dink.knid.com/src/todo.conkyrc
# systemOverview=/home/michiel/.local/share/gnome-shell/extensions/screensaver@dink.knid.com/src/system_overview.conkyrc
# echo sleeping
# sleep 5
# echo killing
# killall conky > /dev/null 2>&1
# sed -i.bak "s/own_window_type = 'dock'/own_window_type = 'desktop'/g" $systemOverview
# sed -i.bak "s/own_window_type = 'dock'/own_window_type = 'desktop'/g" $todo
# sed -i.bak "s/update_interval = 7200/update_interval = 10/g" $todo
# conky -p 1 -q -c $todo &
# conky -p 1 -q -c $systemOverview 
# echo conkiesStarted
# # start screensaver
# xautolock -locker "/home/michiel/.local/share/gnome-shell/extensions/screensaver@dink.knid.com/src/toggle_above_below.sh" -time 1 -corners 0-0- &
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$DIR/resetScript.sh

exit
