import { bind, Binding, Gio, Variable } from "astal";
import { App, Gdk } from "astal/gtk4";
import AstalApps from "gi://AstalApps?version=0.1";
import Hyprland from "gi://AstalHyprland";
import GLib from "gi://GLib?version=2.0";

import { find_app_by_wmclass } from "./utils";

export const LAYER_NAMESPACE = "kofea-shell";
export const TOPBAR_LAYER_NAMESPACE = LAYER_NAMESPACE + "-topbar";
export const BAR_LAYER_NAMESPACE = LAYER_NAMESPACE + "-bar";
export const POPUP_LAYER_NAMESPACE = LAYER_NAMESPACE + "-popup";

export const hypr = Hyprland.get_default();

export function launchStartMenu() {
  console.log("Launching start menu...");
  hypr.dispatch("exec", "$kofea/rofi/launcher.sh");
}

export namespace KofeaShellConfig {
  export const config_dir = `${GLib.getenv("HOME")}/.config/kofea.shell`;
  export const config_file = `${config_dir}/desktop.json`;

  export function readFile(): any | undefined {
    try {
      const [_, raw] = GLib.file_get_contents(config_file);
      const contents = new TextDecoder("utf-8").decode(raw);
      return JSON.parse(contents);
    } catch {}
    return undefined;
  }

  export function dumpFile(obj: any) {
    GLib.mkdir_with_parents(config_dir, 0o755);
    GLib.file_set_contents_full(
      config_file,
      JSON.stringify(obj, null, 4),
      GLib.FileSetContentsFlags.CONSISTENT,
      0o755,
    );
  }

  export function readKey<T>(key: string): T | undefined {
    return readFile()?.[key];
  }
  export function writeKey<T>(key: string, value: T) {
    const obj = readFile() ?? {};
    obj[key] = value;
    return dumpFile(obj);
  }
}

export namespace KofeaApi {
  export const _apps = new AstalApps.Apps();
  export function register_global_actions() {
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
        name: "taskbar-launch-app",
        parameter_type: "s",
        activate: (action, param) => {
          const param_desktop_entry: string | undefined = param?.deep_unpack();
          if (!param_desktop_entry) return;

          const desktop_entry = _apps
            .get_list()
            .find((x) => x.entry == param_desktop_entry);

          if (desktop_entry === undefined) {
            console.log(
              `Could not find desktop entry for app: ${param_desktop_entry}`,
            );
            return;
          }
          desktop_entry.launch();
        },
      },
      {
        name: "taskbar-pin-app",
        parameter_type: "s",
        activate: (action, param) => {
          const param_desktop_entry: string | undefined = param?.deep_unpack();
          if (!param_desktop_entry) return;

          const desktop_entry = _apps
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
      {
        name: "taskbar-unpin-app",
        parameter_type: "s",
        activate: (action, param) => {
          const param_desktop_entry: string | undefined = param?.deep_unpack();
          if (!param_desktop_entry) return;

          KofeaApi.PinnedApps.remove_entry(param_desktop_entry);
        },
      },
      {
        name: "taskbar-move-client-workspace",
        parameter_type: "(si)",
        activate: (action, param) => {
          const params: [string, number] | undefined = param?.deep_unpack();

          if (!params) return;
          const [param_app_addr, ws_id] = params;
          const hypr = Hyprland.get_default();
          hypr.dispatch(
            "movetoworkspace",
            `${ws_id},address:0x${param_app_addr}`,
          );
        },
      },
      {
        name: "taskbar-move-client-new-workspace",
        parameter_type: "s",
        activate: (action, param) => {
          const param_app_addr: string | undefined = param?.deep_unpack();
          if (!param_app_addr) return;
          const hypr = Hyprland.get_default();

          hypr.dispatch(
            "movetoworkspace",
            `${hypr.workspaces.length + 1},address:0x${param_app_addr}`,
          );
        },
      },
      {
        name: "workspace-new",
        activate: () => {
          const hypr = Hyprland.get_default();
          hypr.dispatch("workspace", "emptym");
        },
      },
      {
        name: "workspace-contents-move",
        parameter_type: "(ii)",
        activate: (action, param) => {
          const params: [number, number] | undefined = param?.deep_unpack();
          if (!params) return;
          const [from_ws_id, to_ws_id] = params;
          const from_ws = hypr.get_workspace(from_ws_id);
          from_ws.clients.forEach((x) =>
            hypr.dispatch(
              "movetoworkspace",
              `${to_ws_id},address:0x${x.address}`,
            ),
          );
        },
      },
      {
        name: "workspace-moveto-monitor",
        parameter_type: "(ii)",
        activate: (_, param) => {
          const params: [number, number] | undefined = param?.deep_unpack();
          if (!params) return;
          const [ws_id, m_id] = params;
          const ws = hypr.get_workspace(ws_id);
          const m = hypr.get_monitor(m_id);
          ws.move_to(m);
        },
      },
    ]);
  }

  export namespace Taskbar {
    export interface TaskbarEntry {
      client: Hyprland.Client;
      app: AstalApps.Application | null;
    }

    const workspaces = Variable<Hyprland.Workspace[]>([]).poll(
      200,
      () => hypr?.workspaces ?? [],
    );

    const hyprclients = Variable<Hyprland.Client[]>([]);
    let last_hash = 0;

    workspaces.subscribe((workspaces_) => {
      let clients = workspaces_.flatMap((x) => x.clients);

      let hash = 0;

      // If no clients active, let hash be 0
      // Need to do this before reduce func as it will crash if there are zero clients. Causing bugs
      if (clients.length != 0) {
        hash = clients
          .map((x) => x.workspace.id * x.get_x() * (x.floating ? 2 : 3))
          .reduce((a, b) => (a + 1) * (b + 2));
      }

      if (hash != last_hash) {
        hyprclients.set(clients);
        last_hash = hash;
      }
    });
    const apps = new AstalApps.Apps({
      nameMultiplier: 2,
      entryMultiplier: 1,
      executableMultiplier: 2,
      min_score: -1,
    });

    export const entries: Variable<TaskbarEntry[]> = Variable.derive(
      [hyprclients],
      (x) =>
        x.map((client) => ({
          client,
          app: find_app_by_wmclass(client.class, apps),
        })),
    );
    export function get_entries(): Binding<TaskbarEntry[]> {
      return bind(entries);
    }

    export function client_on_monitor(
      client: Hyprland.Client,
      monitor: Gdk.Monitor | null,
    ): boolean {
      if (!monitor) return true;

      return client.monitor.get_x() == monitor.get_geometry().x;
    }
  }

  export namespace PinnedApps {
    export const pinnedapps_entries = new Variable<string[]>([]);

    export const entries = Variable.derive([pinnedapps_entries], (x) =>
      x
        .map((y) => _apps.get_list().find((a) => a.entry == y))
        .filter((x) => x != undefined),
    );

    export function contains(app: AstalApps.Application): boolean {
      return entries.get().find((x) => x.entry == app.entry) != undefined;
    }

    export function add(app: AstalApps.Application) {
      console.log(`Adding ${app.entry} to pinned apps...`);
      const newArray = pinnedapps_entries.get().concat(app.entry);
      KofeaShellConfig.writeKey("pinned-apps", newArray);
      pinnedapps_entries.set(newArray);
    }

    export function remove_entry(entry: string) {
      console.log(`Removing ${entry} from pinned apps...`);
      const newArray = pinnedapps_entries.get().filter((x) => x != entry);
      KofeaShellConfig.writeKey("pinned-apps", newArray);
      pinnedapps_entries.set(newArray);
    }

    export function refresh() {
      console.log(`Refreshing pinned apps`);
      pinnedapps_entries.set(KofeaShellConfig.readKey("pinned-apps") ?? []);
    }
  }
}
