import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Taskbar from "./Taskbar";
import { GLib, Variable } from "astal";
import { launchStartMenu, BAR_LAYER_NAMESPACE } from "../api";
import SysTray from "./SysTray";
import Clock from "./Clock";
import Workspaces from "./Workspaces";
import MediaControl from "./MediaControl";
import { AudioOutput } from "./AudioOutput";
import PinnedApps from "./PinnedApps";

const theme = Gtk.IconTheme.get_default();

export function TopBar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      namespace={BAR_LAYER_NAMESPACE}
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box vexpand halign={Gtk.Align.START}>
          <box className="container">
            <button className={"start-logo"} onClick={() => launchStartMenu()}>
              <icon icon={"start-menu-icon"} />
            </button>
          </box>
          <box className={"container"}>
            <label label={"wifi / cpu stats"} />
          </box>
          <box className={"container"}>
            <AudioOutput />
          </box>
        </box>
        <box className="container">
          <Clock> </Clock>
        </box>
        <box vexpand halign={Gtk.Align.END}>
          <box className="container">
            <MediaControl />
          </box>
        </box>
      </centerbox>
    </window>
  );
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      namespace={BAR_LAYER_NAMESPACE}
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={BOTTOM | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box vexpand halign={Gtk.Align.START}>
          <box className={"container"}>
            <Workspaces monitor={gdkmonitor} />
            <box className={"gap"} />
            <PinnedApps />
          </box>
        </box>
        <box className="container">
          <Taskbar gdkmonitor={gdkmonitor}></Taskbar>
        </box>
        <box vexpand halign={Gtk.Align.END}>
          <box className="container">
            <SysTray> </SysTray>
          </box>
        </box>
      </centerbox>
    </window>
  );
}
