# Gnome-tweak-screensaver
A gnome extension which operates as a screensaver. I started making this screensaver during the corona quarantaine, and it turned out to be something I wanted to share with others. This is why I made this extension. It isn't perfect documentated, but if you have any questions, you can ask them. 


# Dependencies
The extension makes use of conky (https://github.com/brndnmtthws/conky), todo.txt (https://gitlab.com/bartl/todo-txt-gnome-shell-extension), lua, imagemagick (to take the screenshot and blur it), unclutter and xdotool. 

# Installation
Install this extension just like any other gnome extension. One additional thing must be changed in the source codes of the conkyrc files. Look in each conkyrc file (src/devices.conkyrc, src/system_overview.conkyrc and src/todo.conkyrc), and change the path from which the lua scripts must be loaded. (`lua_load = '...'`, replace the `...`)

The todo.txt file of the Todo.txt extension, must be located in /home/$USER/todo.txt. Otherwise you have to change the paths in the files which use it.

In the file src/toggle_above_below.sh, you can adapt the script to your wishes. I guess the script is straight forward, if any questions, you can ask them to me. 

