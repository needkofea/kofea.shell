import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Taskbar from "./Taskbar";
import { GLib, Variable } from "astal";
import { LAYER_NAMESPACE } from "../globals";
import SysTray from "./SysTray";
import Clock from "./Clock";
import Workspaces from "./Workspaces";

const theme = Gtk.IconTheme.get_default();

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
        <box vexpand halign={Gtk.Align.START}>
          <box className="container">
            <button className={"start-logo"}>
              <icon icon={"start-menu-icon"} />
            </button>
          </box>
          <box className={"container"}>
            <Workspaces monitor={gdkmonitor} />
          </box>
        </box>
        <box className="container">
          <Taskbar gdkmonitor={gdkmonitor}></Taskbar>
        </box>
        <box vexpand halign={Gtk.Align.END}>
          <box className="container">
            <SysTray> </SysTray>
          </box>{" "}
          <box className="container">
            <Clock> </Clock>
          </box>
        </box>
      </centerbox>
    </window>
  );
}
