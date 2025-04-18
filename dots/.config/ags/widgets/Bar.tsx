import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import Taskbar from "./BarWidgets/Taskbar";
import { bind, GLib, Variable } from "astal";
import {
  launchStartMenu,
  BAR_LAYER_NAMESPACE,
  TOPBAR_LAYER_NAMESPACE,
  KofeaApi,
} from "../api";
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

  return (
    <window
      visible
      canFocus={false}
      namespace={TOPBAR_LAYER_NAMESPACE}
      cssClasses={["Bar", "Upper"]}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box vexpand halign={Gtk.Align.START}>
          <box cssClasses={["container"]}>
            <button
              cssClasses={["start-logo"]}
              onClicked={() => launchStartMenu()}
            >
              <image iconName={"start-menu-icon"} />
            </button>
          </box>
          <box cssClasses={["container"]}>
            <NetworkStatus />
          </box>
        </box>
        <box cssClasses={["container"]}>
          <Clock> </Clock>
        </box>
        <box vexpand halign={Gtk.Align.END}>
          <box cssClasses={["container"]}>
            <MediaControl />
          </box>
          <box cssClasses={["container"]}>
            <AudioOutput />
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
      visible
      canFocus={false}
      namespace={BAR_LAYER_NAMESPACE}
      cssClasses={["Bar", "Lower"]}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={BOTTOM | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box vexpand halign={Gtk.Align.START}>
          <box cssClasses={["container"]}>
            <Workspaces monitor={gdkmonitor} />
          </box>
        </box>
        <box cssClasses={["container"]}>
          <button
            onClicked={(ev) => launchStartMenu()}
            cssClasses={["more-apps"]}
            tooltipText={"Open app menu"}
            canFocus={false}
          >
            <image iconName={"user-home-symbolic"} />
          </button>
          <PinnedApps monitor={gdkmonitor} hide_active_apps />
          <Taskbar gdkmonitor={gdkmonitor}></Taskbar>
        </box>
        <box vexpand halign={Gtk.Align.END}>
          <box cssClasses={["container"]}>
            <SysTray> </SysTray>
          </box>
        </box>
      </centerbox>
    </window>
  );
}
