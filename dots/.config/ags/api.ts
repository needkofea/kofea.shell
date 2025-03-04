import { Gio, Variable } from "astal";
import { App } from "astal/gtk4";
import AstalApps from "gi://AstalApps?version=0.1";
import Hyprland from "gi://AstalHyprland";
import GLib from "gi://GLib?version=2.0";

export const LAYER_NAMESPACE = "kofea-shell";
export const TOPBAR_LAYER_NAMESPACE = LAYER_NAMESPACE + "-topbar";
export const BAR_LAYER_NAMESPACE = LAYER_NAMESPACE + "-bar";
export const POPUP_LAYER_NAMESPACE = LAYER_NAMESPACE + "-popup";

export function launchStartMenu() {
  const hypr = Hyprland.get_default();
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
  const _apps = new AstalApps.Apps();
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
    ]);
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
