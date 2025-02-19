import { App, Astal, Gdk, Gtk } from "astal/gtk4";
import Apps from "gi://AstalApps";

const apps = new Apps.Apps({
  nameMultiplier: 2,
  entryMultiplier: 1,
  executableMultiplier: 2,
  min_score: -1,
});

export default function PinnedApps() {
  return (
    <box>
      <label label={"pinnedapps"} />
    </box>
  );
}
