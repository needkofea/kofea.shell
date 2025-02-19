import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import Taskbar from "./BarWidgets/Taskbar";
import { GLib, Variable } from "astal";
import { launchStartMenu, BAR_LAYER_NAMESPACE, readGtkTheme } from "../api";
import SysTray from "./BarWidgets/SysTray";
import Clock from "./BarWidgets/Clock";
import Workspaces from "./BarWidgets/Workspaces";
import MediaControl from "./BarWidgets/MediaControl";
import { AudioOutput } from "./BarWidgets/AudioOutput";
import PinnedApps from "./BarWidgets/PinnedApps";
import NetworkStatus from "./BarWidgets/NetworkStatus";
import Gtk40 from "gi://Gtk";

export function TopBar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
  const theme = Gtk.IconTheme.get_for_display(gdkmonitor.display);

  // return (
  // <window
  //   namespace={BAR_LAYER_NAMESPACE}
  //   className="Bar"
  //   gdkmonitor={gdkmonitor}
  //   exclusivity={Astal.Exclusivity.EXCLUSIVE}
  //   anchor={TOP | LEFT | RIGHT}
  //   application={App}
  // >
  //   <centerbox>
  //     <box vexpand halign={Gtk.Align.START}>
  //       <box className="container">
  //         <button className={"start-logo"} onClick={() => launchStartMenu()}>
  //           <icon icon={"start-menu-icon"} />
  //         </button>
  //       </box>
  //       <box className={"container"}>
  //         <NetworkStatus />
  //       </box>
  //     </box>
  //     <box className="container">
  //       <Clock> </Clock>
  //     </box>
  //     <box vexpand halign={Gtk.Align.END}>
  //       <box className="container">
  //         <MediaControl />
  //       </box>
  //       <box className={"container"}>
  //         <AudioOutput />
  //       </box>
  //     </box>
  //   </centerbox>
  // </window>
  // );
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;
  // console.log("The ttheme is", App.gtkTheme);

  return (
    <window
      visible
      namespace={BAR_LAYER_NAMESPACE}
      cssClasses={["Bar"]}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={BOTTOM | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box vexpand halign={Gtk.Align.START}>
          <box cssClasses={["container"]}>
            <Workspaces monitor={gdkmonitor} />
            <box cssClasses={["gap"]} />
            <PinnedApps />
          </box>
        </box>
        <box cssClasses={["container"]}>
          <Taskbar gdkmonitor={gdkmonitor}></Taskbar>
        </box>
        <box vexpand halign={Gtk.Align.END}>
          <box cssClasses={["container"]}>{/* <SysTray> </SysTray> */}</box>
        </box>
      </centerbox>
    </window>
  );
}
