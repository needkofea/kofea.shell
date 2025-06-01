import { App, Astal, Gdk, Gtk } from "astal/gtk4";
import { POPUP_LAYER_NAMESPACE } from "../api";
import AstalHyprland from "gi://AstalHyprland?version=0.1";
import { bind, Variable } from "astal";

const hypr = AstalHyprland.get_default();

export const appswitcherActive = new Variable(false);

export default function AppSwitcher(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT, TOP } = Astal.WindowAnchor;

  return (
    <window
      visible={bind(appswitcherActive)}
      namespace={POPUP_LAYER_NAMESPACE}
      gdkmonitor={gdkmonitor}
      name={"AppSwitcher"}
      cssClasses={["AppSwitcher"]}
      margin={500}
      exclusivity={Astal.Exclusivity.IGNORE}
      onKeyReleased={(self, _, code) => {
        if (code == Gdk.KEY_Alt_L) {
          appswitcherActive.set(false);
        }
      }}
    >
      <label label={"HELLo"} />
    </window>
  );
}
