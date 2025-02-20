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
  trim_name,
} from "../../utils";
import { KofeaApi } from "../../api";

App.add_action_entries([
  {
    name: "taskbar-close-app",
    parameter_type: "s",
    activate: (action, param) => {
      const param_app_addr: string | undefined = param?.deep_unpack();
      if (!param_app_addr) return;
      const client = Hyprland.get_default().get_client(param_app_addr);
      if (!client) return;
      console.log(
        `Killing app title:[${client.title}] class:[${client.class}] pid:[${client.pid}]`,
      );
      client.kill();
    },
  },
  {
    name: "taskbar-pin-app",
    parameter_type: "s",
    activate: (action, param) => {
      const param_desktop_entry: string | undefined = param?.deep_unpack();
      if (!param_desktop_entry) return;

      const desktop_entry = apps
        .get_list()
        .find((x) => x.entry == param_desktop_entry);

      if (desktop_entry === undefined) {
        console.log(
          `Could not find desktop entry for app: ${param_desktop_entry}`,
        );
        return;
      }
      KofeaApi.PinnedApps.add(desktop_entry);
    },
  },
]);

const apps = new Apps.Apps({
  nameMultiplier: 2,
  entryMultiplier: 1,
  executableMultiplier: 2,
  min_score: -1,
});

const hypr = Hyprland.get_default();

const workspaces = Variable<Hyprland.Workspace[]>([]).poll(
  200,
  () => hypr.workspaces,
);

const hyprclients_raw = Variable<Hyprland.Client[]>([]).poll(
  200,
  () => hypr.clients,
);

const hyprclients = Variable<Hyprland.Client[]>([]);
let last_hash = 0;
workspaces.subscribe((workspaces_) => {
  let clients = workspaces_.flatMap((x) => x.clients);
  let hash = clients
    .map((x) => x.workspace.id * x.get_x())
    .reduce((a, b) => (a + 1) * (b + 2));

  if (hash != last_hash) {
    hyprclients.set(clients);
    last_hash = hash;
  }
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
      gio_menu_additem(
        menu,
        "Add to pinned",
        "app.taskbar-pin-app",
        GLib.Variant.new_string(desktop_entry.entry),
      );
    }

    gio_menu_additem(
      menu,
      "Kill",
      "app.taskbar-close-app",
      GLib.Variant.new_string(client.address),
    );

    // Show the items in the menu
    const popoverMenu = Gtk.PopoverMenu.new_from_model(menu);
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
  const clients = bind(hyprclients).as((clients: Hyprland.Client[]) =>
    clients.filter((x) => x.monitor.get_x() == gdkmonitor.get_geometry().x),
  );

  return (
    <box
      cssClasses={["taskbar"]}
      halign={Gtk.Align.CENTER}
      visible={clients.as((x) => x.length > 0)}
    >
      <box cssClasses={["content"]} halign={Gtk.Align.CENTER}>
        {clients.as((clients: Hyprland.Client[]) =>
          clients
            .map((x) => ({
              client: x,
              desktop: find_app_by_wmclass(x.class, apps),
            }))
            .sort(
              (a, b) =>
                a.client.workspace.id * a.client.get_x() -
                b.client.workspace.id * b.client.get_x(),
            )
            .map(({ client, desktop }) => (
              <button
                canFocus={false}
                tooltipText={bind(client, "title")}
                cssClasses={bind(hypr, "focusedClient").as((a) => [
                  "dock-item",
                  a?.pid == client?.pid ? "focused" : "",
                ])}
                onButtonPressed={(w, ev) => {
                  if (ev.get_button() == 1) {
                    client.focus();
                  }
                  openAppContextMenu(w, ev, client, desktop);
                }}
              >
                <box cssClasses={["item"]}>
                  <image
                    iconName={iconName_asIcon(desktop?.iconName)}
                    file={iconName_asFile(desktop?.iconName)}
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
