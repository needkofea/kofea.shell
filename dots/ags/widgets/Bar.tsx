import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Taskbar from "./Taskbar";
import { Variable } from "astal";
import { LAYER_NAMESPACE } from "../globals";
import TrayBar from "./TrayBar";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      namespace={LAYER_NAMESPACE}
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={BOTTOM | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box vexpand halign={Gtk.Align.START} className="container">
          a
        </box>
        <box className="container">
          <Taskbar gdkmonitor={gdkmonitor}></Taskbar>
        </box>
        <box vexpand halign={Gtk.Align.END} className="container">
          <TrayBar> </TrayBar>
        </box>
      </centerbox>
    </window>
  );
}
