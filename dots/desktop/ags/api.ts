import Hyprland from "gi://AstalHyprland";

export const LAYER_NAMESPACE = "kofea-shell";

export function launchStartMenu() {
  const hypr = Hyprland.get_default();
  console.log("Launching start menu...");
  hypr.dispatch("exec", "$kofea/rofi/launcher.sh");
}
