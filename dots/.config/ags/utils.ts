import { Gio, GLib } from "astal";
import Apps from "gi://AstalApps";
import Hyprland from "gi://AstalHyprland";

export function iconName_isfile(iconName?: string): boolean {
  return iconName?.includes("/") ?? false;
}

export function iconName_asIcon(iconName?: string): string | undefined {
  return iconName_isfile(iconName) ? undefined : iconName;
}
export function iconName_asFile(iconName?: string): string | undefined {
  return iconName_isfile(iconName) ? iconName : undefined;
}

export function strToNumber(str: string): number {
  return parseInt(GLib.base64_encode(Uint8Array.from(str)), 32);
}

/**
 *
 * @param wmclass Attempts to lookup the .desktop entry with the best match for the wmclass.
 * @param apps
 * @returns
 */
export function find_app_by_wmclass(
  wmclass: string,
  apps: Apps.Apps,
): Apps.Application | null {
  const match = apps
    .get_list()
    .find(
      (x) => x.wm_class == wmclass || x.name == wmclass || x.entry == wmclass,
    );

  return match ?? apps.fuzzy_query(wmclass)[0];
}

export function gio_menu_additem(
  menu: Gio.Menu,
  label: string,
  action?: string,
  value?: GLib.Variant,
): Gio.MenuItem {
  const item = Gio.MenuItem.new(label, action ?? null);
  if (value !== undefined && action != undefined) {
    item.set_action_and_target_value(action, value);
  }
  menu.append_item(item);
  return item;
}

/**
 *
 * @param s Trims the string such that it fits within max_len while looking as nice as possible
 * @param max_len Maximum length of the string
 * @returns
 */
export function trim_name(s: string, max_len: number = 32, hard = false) {
  if (!s) return "";

  // If the string is shorter than or equal to max_len, return it as is
  if (s.length <= max_len) return s;

  const originalCutIndex = max_len - 3;

  if (hard) {
    return s.slice(0, originalCutIndex) + "..";
  }

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

export function readGtkTheme(): string | null {
  let theme = GLib.getenv("GTK_THEME");
  if (theme !== null) return theme;

  let config_contents: Uint8Array = new Uint8Array();
  let _;
  // Attempt to read config files
  try {
    [_, config_contents] = GLib.file_get_contents(
      GLib.getenv("HOME")! + "/.config/gtk-4.0/settings.ini",
    );
  } catch {
    // Fallback to gtk3 config
    try {
      [_, config_contents] = GLib.file_get_contents(
        GLib.getenv("HOME")! + "/.config/gtk-3.0/settings.ini",
      );
    } catch {
      return null;
    }
  }

  function extractThemeName(fileContent: string) {
    const themeNameRegex = /gtk-theme-name=([^\s]+)/;
    const match = fileContent.match(themeNameRegex);

    if (match && match[1]) {
      return match[1];
    } else {
      return null; // If no theme name is found
    }
  }

  return extractThemeName(new TextDecoder("utf-8").decode(config_contents));
}

type GroupedWorkspace = {
  [monitor_id: number]: { ws_indices: number[] };
};
export function calc_avail_workspaces(
  hypr: Hyprland.Hyprland,
  ignore_ws_id?: number,
): GroupedWorkspace {
  const max_workspace = Math.max(...hypr.workspaces.map((x) => x.id));

  const grouped_ws: GroupedWorkspace = {};

  for (let i = 0; i < max_workspace; i++) {
    const ws_id = i + 1;

    if (ws_id == ignore_ws_id) continue;
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

  return grouped_ws;
}
