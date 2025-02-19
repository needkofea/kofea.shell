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

export function addToPinnedApps(app: AstalApps.Application) {}

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
