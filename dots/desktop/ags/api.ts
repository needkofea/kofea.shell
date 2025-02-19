import { Gio, Variable } from "astal";
import AstalApps from "gi://AstalApps?version=0.1";
import Hyprland from "gi://AstalHyprland";
import GLib from "gi://GLib?version=2.0";

export const LAYER_NAMESPACE = "kofea-shell";
export const BAR_LAYER_NAMESPACE = LAYER_NAMESPACE + "-bar";

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
  export namespace PinnedApps {
    export const pinnedapps_entries = new Variable<string[]>([]);
    const _apps = new AstalApps.Apps();
    export const entries = Variable.derive([pinnedapps_entries], (x) =>
      x.map((y) => _apps.get_list().find((a) => a.entry == y)),
    );

    export function add(app: AstalApps.Application) {
      console.log(`Adding ${app.entry} to pinned apps...`);
      const newArray = pinnedapps_entries.get().concat(app.entry);
      KofeaShellConfig.writeKey("pinned-apps", newArray);
      pinnedapps_entries.set(newArray);
    }

    export function refresh() {
      console.log(`Refreshing pinned apps`);
      pinnedapps_entries.set(KofeaShellConfig.readKey("pinned-apps") ?? []);
    }
  }
}
