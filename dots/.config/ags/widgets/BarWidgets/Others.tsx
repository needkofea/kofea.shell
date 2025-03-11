import { astalify, Gtk } from "astal/gtk4";

export const Divider = astalify<Gtk.Separator, Gtk.Separator.ConstructorProps>(
  Gtk.Separator,
);

export const Checkbox = astalify<
  Gtk.CheckButton,
  Gtk.CheckButton.ConstructorProps
>(Gtk.CheckButton);
