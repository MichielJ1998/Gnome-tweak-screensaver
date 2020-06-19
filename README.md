# Gnome-tweak-screensaver
A gnome extension which operates as a screensaver. I started making this screensaver during the corona quarantaine, and it turned out to be something I wanted to share with others. This is why I made this extension. It isn't perfect documentated, but if you have any questions, you can ask them. 

<p align="center"><img src="Screenshot from 2020-06-06 01-01-57.png"></p>

# Dependencies
The extension makes use of conky (https://github.com/brndnmtthws/conky), lua, imagemagick (to take the screenshot and blur it), xautolock, unclutter and xdotool. 

`sudo apt install conky lua5.3 imagemagick xautolock unclutter xdotool`

One of the conky example files, also uses the todo.txt gnome extension (https://gitlab.com/bartl/todo-txt-gnome-shell-extension).

# Installation


You will need to restart gnome to be able to see the extension in the extension menu of the tweak tool. Normally Alt+F2 and then entering r should do it.



Install this extension just like any other gnome extension. This means placing the folder `screensaver@dink.knid.com` in to `~/.local/share/gnome-shell/extensions/` . Another option is to clone the Gnome-tweak-screensaver into your home directory (`~/`) and by executing following command you can create a symbolic link to the correct folder: `ln -s ~/Gnome-tweak-screensaver/screensaver@dink.knid.com ~/.local/share/gnome-shell/extensions/screensaver@dink.knid.com` . This way you can keep everything in the git directory. You will need to restart gnome to be able to see extension in the extension menu of the tweak tool. Normally `Alt+F2` and then entering  `r` shoud do it.

In the folder `screensaver@dink.knid.com/src/ownFiles` you can place your own .conkyrc files. When enabling/disabling the screensaver, the conky files in this folder will be triggered. An important setting in your conkyrc files is following line: `own_window_type = 'desktop'`. You can see in the three examples files in this folder, that this setting is in it. The script will change the window type from desktop to dock (and inverse) to enable (disable) to screensaver, to bring them to the foreground or background. The three examples also make use of lua scripts, if your conky file also uses a lua script, I suggest to place it in this folder too.

## Example files
If you want to use the example files these are some requirements/steps to do, in order to use them.

One additional thing must be changed in the source code of the conkyrc files. Look in each conkyrc file (src/ownFile/devices.conkyrc, src/ownFile/system_overview.conkyrc and src/ownFile/todo.conkyrc), and change the path from which the lua scripts must be loaded. (`lua_load = '...'`, replace the `...` with the absolute path of the lua script.)

The todo.txt file of the Todo.txt extension, must be located in /home/$USER/todo.txt. Otherwise you have to change the paths in the files which use it.

In the file `src/toggle_above_below.sh`, you can adapt the script to your wishes. I guess the script is straight forward, if any questions, you can ask them to me. E.g. I introduced an extra change in the todo.conkyrc file. By using this command `	sed -u -i "s/update_interval = 10/update_interval = 7200/g" $todo`, the update interval of the todo conky file is edited. I've done that because the values of my todo list cannot change while the screensaver is active, this reduces overhead of running the needed lua file every 10seconds. It is important that you also change the value back to its original value, this can be done in the `src/resetScript.sh`.     

# Usage
In the top panel, two icons will be added. The first one is a lock and unlock button, this is to start en stop the screensaver. Currently, when the screensaver is started, the mouse disappears (using unclutter) and the mouse cannot move any more (it is possible that you have to change the id of your mouse in the toggle_above_below.sh file). So to disable the screensaver you have to use the shortcut `<CTRL>Escape`. 

The other icon, is the coffee icon. This sets the timer of the automated screensaver. If the cup is empty, then after 1 minute of inactivity the screensaver will start. If the cup is full, then after 5minutes of inactivity the screensaver will start. If the cup is full and orange, then the screensaver won't start automatically.
