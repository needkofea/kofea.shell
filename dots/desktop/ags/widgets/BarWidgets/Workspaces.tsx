import { bind } from "astal";
import { Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";

export type WorkspaceProps = {
  monitor: Gdk.Monitor;
};

export default function Workspaces({ monitor }: WorkspaceProps) {
  const hypr = Hyprland.get_default();

  const workspaces = bind(hypr, "workspaces").as(
    (x) =>
      x
        .filter((ws) => ws.monitor?.x == monitor.geometry.x)
        .filter((ws) => !(ws.id >= -99 && ws.id <= -2))
        .sort((a, b) => a.id - b.id), // filter out special workspaces,
  );

  return (
    <box className="Workspaces">
      {workspaces.as((wss) =>
        wss.map((ws) => (
          <button
            tooltipText={bind(ws, "clients").as((x) =>
              x.map((c, index) => `${c.title}`).join("\n"),
            )}
            className={bind(hypr, "focusedWorkspace").as((fw) =>
              ws === fw ? "focused" : "",
            )}
            onClicked={() => ws.focus()}
          >
            {ws.id}
          </button>
        )),
      )}
    </box>
  );
}
