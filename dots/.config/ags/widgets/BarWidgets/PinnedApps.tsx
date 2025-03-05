import { App, Astal, Gdk, Gtk } from "astal/gtk4";
import Apps from "gi://AstalApps";
import { KofeaApi, launchStartMenu } from "../../api";
import { bind, Gio, GLib } from "astal";
import {
  gio_menu_additem,
  iconName_asFile,
  iconName_asIcon,
} from "../../utils";

function openAppContextMenu(
  widget: Gtk.Widget,
  event: Gdk.ButtonEvent,
  app_entry: Apps.Application,
) {
  // Check if the right mouse button (button 3) was clicked
  if (event.get_button() === 3) {
    // Create a menu
    let menu = new Gio.Menu();

    // Create menu items

    gio_menu_additem(
      menu,
      "Remove",
      "app.taskbar-unpin-app",
      GLib.Variant.new_string(app_entry.entry),
    );
    // Show the items in the menu
    const popoverMenu = Gtk.PopoverMenu.new_from_model(menu);
    popoverMenu.set_has_arrow(false);
    // Pop up the menu at the cursor position
    let [_, x, y] = event.get_position();
    popoverMenu.set_parent(widget);
    // popoverMenu.set_pointing_to(new Gdk.Rectangle({ x: x, y: y }));
    popoverMenu.popup();
  }
}

export default function PinnedApps() {
  return (
    <box cssClasses={["pinned-apps"]}>
      {bind(KofeaApi.PinnedApps.entries).as((apps) =>
        apps.map((app) => (
          <button
            onClicked={(ev) => app.launch()}
            cssClasses={["item"]}
            tooltipText={app.name}
            canFocus={false}
            onButtonReleased={(w, ev) => {
              if (ev.get_button() === 3) openAppContextMenu(w, ev, app);
            }}
          >
            <image
              iconName={iconName_asIcon(app?.iconName)}
              file={iconName_asFile(app?.iconName)}
            />
          </button>
        )),
      )}
    </box>
  );
}
