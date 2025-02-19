import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import Apps from "gi://AstalApps";
import { bind, Variable } from "astal";
import Hyprland from "gi://AstalHyprland";

const apps = new Apps.Apps({
  nameMultiplier: 2,
  entryMultiplier: 1,
  executableMultiplier: 2,
  min_score: -1,
});

const hypr = Hyprland.get_default();

function trim_name(s: string, max_len: number = 32) {
  if (!s) return "";

  // If the string is shorter than or equal to max_len, return it as is
  if (s.length <= max_len) return s;

  const originalCutIndex = max_len - 3;
  // Find the last space within the allowed max_len
  const truncIndex = s.lastIndexOf(" ", originalCutIndex);

  // If a space is found, and position isn't too far of, truncate the string at that point and add "..."
  if (Math.abs(truncIndex - originalCutIndex) < 4) {
    if (truncIndex !== -1) {
      return s.slice(0, truncIndex) + "..";
    }
  }

  return s.slice(0, originalCutIndex) + "..";
}

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

function find_app_by_wmclass(wmclass: string): Apps.Application | null {
  const match = apps
    .get_list()
    .find(
      (x) => x.wm_class == wmclass || x.name == wmclass || x.entry == wmclass,
    );

  return match ?? apps.fuzzy_query(wmclass)[0];
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
              desktop: find_app_by_wmclass(x.class),
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
                onClicked={() => client.focus()}
              >
                <box>
                  <image iconName={desktop?.iconName}></image>
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
