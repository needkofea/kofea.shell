import { bind, Gio, GLib } from "astal";
import { Gdk, Gtk } from "astal/gtk4";
import Hyprland from "gi://AstalHyprland";
import {
  calc_avail_workspaces,
  gio_menu_additem,
  trim_name,
} from "../../utils";

export type WorkspaceProps = {
  monitor: Gdk.Monitor;
};

function openContextMenu(
  widget: Gtk.Widget,
  event: Gdk.ButtonEvent,
  ws: Hyprland.Workspace,
) {
  // Check if the right mouse button (button 3) was clicked
  if (event.get_button() !== 3) {
    return;
  }
  const hypr = Hyprland.get_default();

  // Create a menu
  let menu = new Gio.Menu();

  // Create menu items

  // Move Workspace Contents
  {
    let submenu = new Gio.Menu();
    const grouped_ws = calc_avail_workspaces(hypr);
    Object.entries(grouped_ws).forEach(([key, group], _, arr) => {
      const use_submenu = hypr.monitors.length > 1;
      const workspace_menu_sub = use_submenu ? new Gio.Menu() : submenu;

      group.ws_indices.forEach((ws_index) => {
        const target_ws: Hyprland.Workspace | null =
          hypr.get_workspace(ws_index);
        let workspace_name = `Workspace ${ws_index}`;

        if (target_ws && target_ws?.get_name() != ws_index + "") {
          workspace_name = ws.get_name();
        }
        gio_menu_additem(
          workspace_menu_sub,
          `${ws_index}. ${workspace_name}`,
          "app.workspace-contents-move",
          new GLib.Variant("(ii)", [ws.id, ws_index]),
        );
      });

      if (use_submenu) {
        const workspaces_peek_text = group.ws_indices.join(", ");

        if (key == "-1") {
          submenu.append_submenu(`Empty Workspaces`, workspace_menu_sub);
        } else {
          submenu.append_submenu(
            `Monitor ${key} \t[ ${trim_name(workspaces_peek_text, 6)} ]`,
            workspace_menu_sub,
          );
        }
      }
    });
    menu.append_submenu("Move Contents", submenu);
  }

  {
    let submenu = new Gio.Menu();
    const monitors = hypr.monitors;
    monitors.forEach((monitor) => {
      if (ws.monitor.id == monitor.id) return;
      gio_menu_additem(
        submenu,
        `Monitor ${monitor.id}`,
        "app.workspace-moveto-monitor",
        new GLib.Variant("(ii)", [ws.id, monitor.id]),
      );
    });
    menu.append_submenu("Move to Monitor", submenu);
  }
  gio_menu_additem(menu, `New Workspace`, "app.workspace-new");

  // Show the items in the menu
  const popoverMenu = Gtk.PopoverMenu.new_from_model(menu);
  popoverMenu.set_has_arrow(false);
  // Pop up the menu at the cursor position
  let [_, x, y] = event.get_position();
  popoverMenu.set_parent(widget);
  // popoverMenu.set_pointing_to(new Gdk.Rectangle({ x: x, y: y }));
  popoverMenu.popup();
}

export default function Workspaces({ monitor }: WorkspaceProps) {
  const hypr = Hyprland.get_default();

  const workspaces = bind(hypr, "workspaces").as(
    (x) =>
      x
        .filter((ws) => ws.monitor?.x == monitor.geometry.x)
        .filter((ws) => !(ws.id >= -99 && ws.id <= -2))
        .sort((a, b) => a.id - b.id), // filter out special workspaces,
  );

  return (
    <box cssClasses={["Workspaces"]}>
      {workspaces.as((wss) =>
        wss.map((ws) => (
          <button
            canFocus={false}
            tooltipText={bind(ws, "clients").as((x) =>
              x.map((c, index) => `${c.title}`).join("\n"),
            )}
            cssClasses={bind(hypr, "focusedWorkspace").as((fw) => [
              ws === fw ? "focused" : "",
            ])}
            onClicked={() => ws.focus()}
            onButtonReleased={(w, ev) => {
              if (ev.get_button() === 3) openContextMenu(w, ev, ws);
            }}
          >
            {ws.id}
          </button>
        )),
      )}
    </box>
  );
}
