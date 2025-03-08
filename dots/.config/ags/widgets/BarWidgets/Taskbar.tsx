import { bind, Gio, GLib, Variable } from "astal";
import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import Apps from "gi://AstalApps";
import Hyprland from "gi://AstalHyprland";
import Gtk40 from "gi://Gtk";
import {
  find_app_by_wmclass,
  gio_menu_additem,
  iconName_asFile,
  iconName_asIcon,
  strToNumber,
  trim_name,
} from "../../utils";
import { hypr, KofeaApi } from "../../api";

const apps = new Apps.Apps({
  nameMultiplier: 2,
  entryMultiplier: 1,
  executableMultiplier: 2,
  min_score: -1,
});

function openAppContextMenu(
  widget: Gtk.Widget,
  event: Gdk.ButtonEvent,
  client: Hyprland.Client,
  desktop_entry?: Apps.Application | null,
) {
  // Check if the right mouse button (button 3) was clicked
  if (event.get_button() === 3) {
    // Create a menu
    let menu = new Gio.Menu();

    // Create menu items
    if (desktop_entry) {
      if (KofeaApi.PinnedApps.contains(desktop_entry)) {
        gio_menu_additem(
          menu,
          `Unpin "${desktop_entry.name}" from taskbar`,
          "app.taskbar-unpin-app",
          GLib.Variant.new_string(desktop_entry.entry),
        );
      } else {
        gio_menu_additem(
          menu,
          `Pin "${desktop_entry.name}" to taskbar`,
          "app.taskbar-pin-app",
          GLib.Variant.new_string(desktop_entry.entry),
        );
      }

      gio_menu_additem(
        menu,
        "New Instance",
        "app.taskbar-launch-app",
        GLib.Variant.new_string(desktop_entry.entry),
      );
    }
    let workspace_menu = new Gio.Menu();

    const max_workspace = Math.max(...hypr.workspaces.map((x) => x.id));

    const grouped_ws: {
      [monitor_id: number]: { ws_indices: number[] };
    } = {};

    for (let i = 0; i < max_workspace; i++) {
      const ws_id = i + 1;

      if (ws_id == client.workspace.id) continue;
      const ws: Hyprland.Workspace | null = hypr.get_workspace(ws_id);
      const group_id = ws?.monitor?.id ?? -1;
      // let workspace_name = `Workspace ${ws_id}`;

      // if (ws && ws?.get_name() != ws_id) {
      //   workspace_name = ws.get_name();
      // }

      if (!grouped_ws[group_id]) {
        grouped_ws[group_id] = { ws_indices: [] };
      }

      grouped_ws[group_id].ws_indices.push(ws_id);
    }

    Object.entries(grouped_ws).forEach(([key, group], _, arr) => {
      const use_submenu = arr.length > 1;
      const workspace_menu_sub = use_submenu ? new Gio.Menu() : workspace_menu;

      group.ws_indices.forEach((ws_index) => {
        const ws: Hyprland.Workspace | null = hypr.get_workspace(ws_index);
        let workspace_name = `Workspace ${ws_index}`;

        if (ws && ws?.get_name() != ws_index + "") {
          workspace_name = ws.get_name();
        }
        gio_menu_additem(
          workspace_menu_sub,
          `${ws_index}. ${workspace_name}`,
          "app.taskbar-move-client-workspace",
          new GLib.Variant("(si)", [client.address, ws_index]),
        );
      });

      if (use_submenu) {
        const workspaces_peek_text = group.ws_indices.join(", ");
        if (key == "-1") {
          workspace_menu.append_submenu(`Empty Workspaces`, workspace_menu_sub);
        } else {
          workspace_menu.append_submenu(
            `Monitor ${key} \t[ ${trim_name(workspaces_peek_text, 6)} ]`,
            workspace_menu_sub,
          );
        }
      }
    });

    gio_menu_additem(
      workspace_menu,
      `New workspace`,
      "app.taskbar-move-client-new-workspace",
      new GLib.Variant("s", client.address),
    );
    menu.append_submenu("Move to workspace", workspace_menu);

    gio_menu_additem(
      menu,
      "Quit",
      "app.taskbar-close-app",
      GLib.Variant.new_string(client.address),
    );

    // Show the items in the menu
    const popoverMenu = Gtk.PopoverMenu.new_from_model(menu);
    popoverMenu.hasArrow = false;
    // Pop up the menu at the cursor position
    let [_, x, y] = event.get_position();
    popoverMenu.set_parent(widget);
    // popoverMenu.set_pointing_to(new Gdk.Rectangle({ x: x, y: y }));
    popoverMenu.popup();
  }
}

export type TaskbarProps = {
  gdkmonitor: Gdk.Monitor;
};

export default function Taskbar({ gdkmonitor }: TaskbarProps) {
  const items = KofeaApi.Taskbar.get_entries().as((items) =>
    items.filter((x) =>
      KofeaApi.Taskbar.client_on_monitor(x.client, gdkmonitor),
    ),
  );

  return (
    <box
      cssClasses={["taskbar"]}
      halign={Gtk.Align.CENTER}
      visible={items.as((x) => x.length > 0)}
    >
      <box cssClasses={["content"]} halign={Gtk.Align.CENTER}>
        {items.as((x) =>
          x
            .map((y) => ({
              sort_index:
                y.client.workspace.id * x.length +
                (y.client.floating
                  ? strToNumber(y.client.class) % x.length // Use name to determine the sort. Modulus by x.length so it doesnt mess up the workspace sorting
                  : y.client.get_x()),
              ...y,
            }))
            .sort((a, b) => a.sort_index - b.sort_index)
            .map(({ client, app }) => (
              <button
                canFocus={false}
                tooltipText={bind(client, "title")}
                cssClasses={bind(hypr, "focusedClient").as((a) => [
                  "dock-item",
                  a?.address == client?.address ? "focused" : "",
                ])}
                onButtonPressed={(w, ev) => {
                  if (ev.get_button() == 1) {
                    client.focus();
                    hypr.dispatch("bringactivetotop", "");
                  }
                  openAppContextMenu(w, ev, client, app);
                }}
              >
                <box cssClasses={["item"]}>
                  <image
                    iconName={iconName_asIcon(app?.iconName)}
                    file={iconName_asFile(app?.iconName)}
                  ></image>
                  <label
                    label={bind(client, "title").as(
                      (title) => `${trim_name(title, 16)}`,
                    )}
                    valign={Gtk.Align.CENTER}
                  ></label>
                </box>
              </button>
            )),
        )}
      </box>
    </box>
  );
}
