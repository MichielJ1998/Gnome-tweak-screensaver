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
const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;
const GdkPixbuf = imports.gi.GdkPixbuf;
const St = imports.gi.St;
const Clutter = imports.gi.Clutter;

var ArgosLineView = new Lang.Class({
  Name: "ArgosLineView",
  Extends: St.BoxLayout,

  _init: function(line) {
    this.parent({
      style_class: "argos-line-view"
    });

    if (typeof line !== "undefined")
      this.setLine(line);
  },

  setLine: function(image) {

    this.remove_all_children();

    // Source: https://github.com/GNOME/gnome-maps (mapSource.js)
    let bytes = GLib.Bytes.new(GLib.base64_decode(image));
    let stream = Gio.MemoryInputStream.new_from_bytes(bytes);

    try {
      let pixbuf = GdkPixbuf.Pixbuf.new_from_stream(stream, null);

      // TextureCache.load_gicon returns a square texture no matter what the Pixbuf's
      // actual dimensions are, so we request a size that can hold all pixels of the
      // image and then resize manually afterwards
      let size = Math.max(pixbuf.width, pixbuf.height);
      let texture = St.TextureCache.get_default().load_gicon(null, pixbuf, size, 1, 1.0);

      let aspectRatio = pixbuf.width / pixbuf.height;

      texture.set_size(16, 16); // size 16x16

      this.add_child(texture);
      // Do not stretch the texture to the height of the container
      this.child_set_property(texture, "y-fill", false);
    } catch (error) {
      log("Unable to load image from Base64 representation: " + error);
    }

  },

  // 
});
