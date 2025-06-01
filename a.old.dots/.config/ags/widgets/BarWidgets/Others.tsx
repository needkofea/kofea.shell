import { bind } from "astal";
import { astalify, Gtk } from "astal/gtk4";
import AstalApps from "gi://AstalApps?version=0.1";

export const Divider = astalify<Gtk.Separator, Gtk.Separator.ConstructorProps>(
  Gtk.Separator,
);

export const Checkbox = astalify<
  Gtk.CheckButton,
  Gtk.CheckButton.ConstructorProps
>(Gtk.CheckButton);
