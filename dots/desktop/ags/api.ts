import Hyprland from "gi://AstalHyprland";

export const LAYER_NAMESPACE = "kofea-shell";
export const BAR_LAYER_NAMESPACE = LAYER_NAMESPACE + "-bar";

export function launchStartMenu() {
  const hypr = Hyprland.get_default();
  console.log("Launching start menu...");
  hypr.dispatch("exec", "$kofea/rofi/launcher.sh");
}
