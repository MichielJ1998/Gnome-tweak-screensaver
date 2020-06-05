# Gnome-tweak-screensaver
A gnome extension which operates as a screensaver. I started making this screensaver during the corona quarantaine, and it turned out to be something I wanted to share with others. This is why I made this extension. It isn't perfect documentated, but if you have any questions, you can ask them. 

<p align="center"><img src="Screenshot from 2020-06-06 01-01-57.png"></p>

# Dependencies
The extension makes use of conky (https://github.com/brndnmtthws/conky), todo.txt (https://gitlab.com/bartl/todo-txt-gnome-shell-extension), lua, imagemagick (to take the screenshot and blur it), xautolock, unclutter and xdotool. 

# Installation
Install this extension just like any other gnome extension. One additional thing must be changed in the source codes of the conkyrc files. Look in each conkyrc file (src/devices.conkyrc, src/system_overview.conkyrc and src/todo.conkyrc), and change the path from which the lua scripts must be loaded. (`lua_load = '...'`, replace the `...`)

The todo.txt file of the Todo.txt extension, must be located in /home/$USER/todo.txt. Otherwise you have to change the paths in the files which use it.

In the file src/toggle_above_below.sh, you can adapt the script to your wishes. I guess the script is straight forward, if any questions, you can ask them to me. 

# Usage
In the top panel, two icons will be added. The first one is a lock and unlock button, this is to start en stop the screensaver. Currently, when the screensaver is started, the mouse disappears (using unclutter) and the mouse cannot move any more (it is possible that you have to change the id of your mouse in the toggle_above_below.sh file). So to disable the screensaver you have to use the shortcut `<CTRL>Escape`. 

The other icon, is the coffee icon. This sets the timer of the automated screensaver. If the cup is empty, then after 1 minute of inactivity the screensaver will start. If the cup is full, then after 5minutes of inactivity the screensaver will start. If the cup is full and orange, then the screensaver won't start automatically.
