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

const Lang = imports.lang;
const Gio = imports.gi.Gio;
const PanelMenu = imports.ui.panelMenu;
const Main = imports.ui.main;
const Shell = imports.gi.Shell;
const Meta = imports.gi.Meta;
const St = imports.gi.St;
const GLib = imports.gi.GLib;


const Extension = imports.misc.extensionUtils.getCurrentExtension();
const toggleKey = "toggle-key";

var ScreensaverButton = new Lang.Class({
  Name: "ScreensaverButton",
  Extends: PanelMenu.Button,

  _init: function() {
    this.parent(0, "", false);

    // // this._file = file;
    // this._updateInterval = null;
    this.iconPath = Extension.dir.get_path() + '/icons';
    this.icon = new St.Icon({
    	//icon_name : 'security-low-symbolic',
    	gicon : Gio.icon_new_for_string(this.iconPath + '/system-unlocked-screen-symbolic.svg'),
    	style_class : 'system-status-icon',
    });

    this.add_child(this.icon)
    
    this.settings = this.getSettings();
    //log(this.settings);
  },

  // base64 image
  setIcon: function(icon, style=null) {
  	this.icon.set_gicon(Gio.icon_new_for_string(this.iconPath + icon));
  	this.icon.set_style_class_name("system-status-icon");
  	if (style != null) {
	  	this.icon.add_style_class_name(style);
  	} 
  },

  getSettings: function() {
    let GioSSS = Gio.SettingsSchemaSource;
    let schemaSource = GioSSS.new_from_directory(
      Extension.dir.get_child("schemas").get_path(),
      GioSSS.get_default(),
      false
    );
    let schemaObj = schemaSource.lookup(
      'org.gnome.shell.extensions.screensaver', true);
    if (!schemaObj) {
      throw new Error('cannot find schemas');
    } 
    return new Gio.Settings({ settings_schema : schemaObj });
  },

  _addKeyBinding: function(key, keyFunction) {
      let mode = Shell.ActionMode;
      if (typeof mode == 'undefined') {
          mode = Shell.KeyBindingMode;
      }
      Main.wm.addKeybinding(key, this.settings, Meta.KeyBindingFlags.NONE,
          mode.ALL, keyFunction);    
  },

  _removeKeyBinding: function(key) {
    // if (Main.wm.removeKeybinding) {
        Main.wm.removeKeybinding(key);
    // } else {
        // global.display.remove_keybinding(key);
    // }
  },
  _installShortcuts: function(f) {
    this._addKeyBinding(toggleKey, Lang.bind(this, f));
  }
  

  // destroy: function() {
  //   super.destroy();
  //   _removeKeyBinding(key);
  // }


});
