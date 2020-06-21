/*
 * Argos - Create GNOME Shell extensions in seconds
 *
 * Copyright (c) 2016-2018 Philipp Emanuel Weidmann <pew@worldwidemann.com>
 *
 * Nemo vir est qui mundum non reddat meliorem.
 *
 * Released under the terms of the GNU General Public License, version 3
 * (https://gnu.org/licenses/gpl.html)
 */

const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;
const Main = imports.ui.main;
const Mainloop = imports.mainloop;

const Extension = imports.misc.extensionUtils.getCurrentExtension();
const ScreensaverButton = Extension.imports.button.ScreensaverButton;

const dirPath = Extension.dir.get_path();
const unlockedImage = "/system-unlocked-screen-symbolic.svg";
const lockedImage = "/system-locked-screen-symbolic.svg";
const caffeineOff = "/my-caffeine-off-symbolic.svg";
const caffeineOn1 = "/my-caffeine-on-1-symbolic.svg";
const caffeineOn2 = "/my-caffeine-on-2-symbolic.svg";
const caffeineOn3 = "/my-caffeine-on-3-symbolic.svg";
const caffeineOn4 = "/my-caffeine-on-4-symbolic.svg";
const toggleKey = "toggle-key";


function init() {
	
}

function enable() {
	log("Screensaver: Enabling extension.")
	
	this.lockStatus = false; // currently locked or not
	this.caffeineStatus = 1; // 0 = 1min, 1 = 5min, 2 = off
	this.prefCafStatus = this.caffeineStatus;
	this.lockedButton = null;
	this.caffeineButton = null;
	this.buttons = [];

	this.lockedButton = new ScreensaverButton();
	this.lockedButton.setIcon(unlockedImage);
	this.lockedButton.connect("button-press-event", () => {
	  log("Screensaver: LockButton was used.")
	  toggleLock();
	});
	this.lockedButton._installShortcuts(function() {
		log("Screensaver: <Control>Escape was used.")
        toggleLock();
    });
	this.buttons.push(this.lockedButton);

	this.caffeineButton = new ScreensaverButton();
	this.caffeineButton.setIcon(caffeineOn3);
	this.caffeineButton.connect("button-press-event", () => {
	  log("Screensaver: caffeineButton was used.");
	  toggleCaffeine();

	});
	this.buttons.push(this.caffeineButton);
	//GLib.spawn_command_line_async("sh -c '"+dirPath+"/src/init.sh'"); // set the correct files for conky
	GLib.spawn_command_line_async("sh -c '"+dirPath+"/src/toggle_above_below.sh off'");

	Main.panel.addToStatusArea("lockedButton", this.lockedButton, 0, "right");
	Main.panel.addToStatusArea("caffeineButton", this.caffeineButton, 1, "right");
	//addButtons();
	updateXautolock();
}

function disable() {
	log("Screensaver: Disabling extension.")
	this.lockedButton._removeKeyBinding(toggleKey);

	for (let i = 0; i < this.buttons.length; i++) {
		this.buttons[i].destroy();
	}
	this.buttons = [];
}


function toggleLock() {
	
	
	if (this.lockStatus) {
		log("Screensaver: Unlocking.")

		this.lockedButton.setIcon(unlockedImage);
		GLib.spawn_command_line_async("sh -c '"+dirPath+"/src/toggle_above_below.sh off'");
		updateXautolock();
	} else {
		let root_geo = 	GLib.spawn_command_line_sync("sh -c 'xwininfo -root | grep geometry' ");
		let currWinGeo = GLib.spawn_command_line_sync("sh -c 'xwininfo -id $(xdotool getactivewindow) | grep geometry'");
		if (root_geo.toString() != currWinGeo.toString()) {
			log("Screensaver: Locking.")

			this.lockedButton.setIcon(lockedImage, "orange");
			GLib.spawn_command_line_async("sh -c '"+dirPath+"/src/toggle_above_below.sh on'");
		} else {
			log("Screensaver: Cannot lock due to fullscreen activity.")

			GLib.spawn_command_line_async(`sh -c 'notify-send -u critical "Please disable Xautolock when using fullscreen" "Disable it by toggling the coffee icon until it is orange." '`)
			return;
		}
	}
	this.lockStatus = !this.lockStatus;

}

function toggleCaffeine() {
	log("Screensaver: toggling the caffeine button.")

	if (this.caffeineStatus == 0) {
      this.caffeineButton.setIcon(caffeineOn3);
      this.caffeineStatus = 1;
	} else if (this.caffeineStatus == 1) {
      this.caffeineButton.setIcon(caffeineOn4, "orange");
      this.caffeineStatus = 2;
	} else if (this.caffeineStatus == 2) {
      this.caffeineButton.setIcon(caffeineOff);
      this.caffeineStatus = 0;
	}
	updateXautolock();	
}

function updateXautolock(){
	log("Screensaver: Updating Xautolock.")

	GLib.spawn_command_line_async("sh -c 'killall xautolock'");
	if (this.caffeineStatus == 0) {
		GLib.spawn_command_line_async(`sh -c "xautolock -locker 'xdotool key ctrl+Escape' -time 1 -corners 0-0- &"`);

	} else if (this.caffeineStatus == 1) {
		GLib.spawn_command_line_async(`sh -c "xautolock -locker 'xdotool key ctrl+Escape' -time 5 -corners 0-0- &"`);

	} 
	GLib.spawn_command_line_async("sh -c 'xautolock -unlocknow'");

}