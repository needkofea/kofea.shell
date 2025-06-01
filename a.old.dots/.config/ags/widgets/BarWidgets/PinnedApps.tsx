import { App, Astal, Gdk, Gtk } from "astal/gtk4";
import Apps from "gi://AstalApps";
import { KofeaApi, launchStartMenu } from "../../api";
import { bind, Gio, GLib, Variable } from "astal";
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
      `Unpin "${app_entry.name}" from taskbar`,
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

interface PinnedAppsProps {
  monitor?: Gdk.Monitor;
  hide_active_apps?: boolean;
}

export default function PinnedApps({
  monitor,
  hide_active_apps,
}: PinnedAppsProps) {
  const pinnedApps = Variable.derive(
    [KofeaApi.PinnedApps.entries, KofeaApi.Taskbar.entries],
    (pinned, taskbar) => {
      if (!hide_active_apps) {
        return pinned;
      }
      return pinned.filter(
        (x) =>
          taskbar
            .filter((y) =>
              KofeaApi.Taskbar.client_on_monitor(y.client, monitor ?? null),
            )
            .findIndex((y) => y.app?.entry === x.entry) === -1,
      );
    },
  );

  return (
    <box cssClasses={["pinned-apps"]}>
      {bind(pinnedApps).as((apps) =>
        apps
          .filter((x) => x)
          .map((app) => (
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
