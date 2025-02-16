import { bind, register, Variable } from "astal";
import { App, Astal, Gdk, Gtk } from "astal/gtk3";
import Mpris from "gi://AstalMpris";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";
import GObject from "gi://GObject?version=2.0";

const mpris = Mpris.Mpris.new();

const current_player = Variable<null | Mpris.Player>(null);

const selectPlayerAction = new Gio.SimpleAction({
  name: "media-control-select-player",
  parameter_type: GLib.VariantType.new("i"),
});

selectPlayerAction.connect("activate", (action, param) => {
  const playerIndex: number = param?.deep_unpack() ?? -1;
  print(`MediaControl: Selected player: ${playerIndex}!`);
  if (playerIndex < 0) {
    current_player.set(null);
    return;
  }
  current_player.set(mpris.players[playerIndex]);
});

/**
 * Automatically selects the next player if current_player is yeeted.
 */
function autoselect_next_player() {
  if (current_player.get() == null && mpris.players.length > 0) {
    current_player.set(mpris.players[mpris.players.length - 1]);
  }
}

mpris.connect("player-added", (x) => {
  autoselect_next_player();
});

mpris.connect("player-closed", (x) => {
  setTimeout(() => {
    if (!current_player.get()?.available) {
      current_player.set(null);
      autoselect_next_player();
    }
  });
});

autoselect_next_player();

App.add_action(selectPlayerAction);

function trim_name(s: string, max_len: number = 32) {
  if (!s) return "";
  if (s.length > max_len) {
    return s.slice(0, max_len - 3) + "...";
  }
  return s;
}

export default function MediaControl() {
  const avail_players = bind(mpris, "players").as((players) => {
    let section = new Gio.Menu();
    players.forEach((p, index) => {
      let mItem = new Gio.MenuItem();
      const label = `[${p.entry}] ${p.title} - ${p.artist}`;
      const max_len = 48;
      mItem.set_label(
        label.length > max_len ? label.slice(0, max_len - 3) + "..." : label,
      );
      mItem.set_action_and_target_value(
        "app.media-control-select-player",
        GLib.Variant.new_int32(index),
      );
      section.append_item(mItem);
    });

    return section;
  });

  return (
    <box className={"media-control"}>
      {bind(current_player).as((player) => {
        return (
          <box>
            <menubutton
              className={"player-select-btn"}
              halign={Gtk.Align.START}
              direction={Gtk.ArrowType.UP}
              usePopover={false}
              menuModel={avail_players}
            >
              <box className={"media-control-player"}>
                <label className={"logo"} label={" "} />
                <label
                  label={player ? `${player?.entry}` : "No player selected"}
                />
              </box>
            </menubutton>

            {player ? (
              <box className={"controls"}>
                <button
                  onClickRelease={() => player.previous()}
                  sensitive={bind(player, "can_go_previous")}
                >
                  <icon icon={"media-skip-backward"} />
                </button>
                <button onClickRelease={() => player.play_pause()}>
                  <icon
                    icon={bind(player, "playback_status").as((x) =>
                      x == Mpris.PlaybackStatus.PLAYING
                        ? "media-playback-pause"
                        : "media-playback-start",
                    )}
                  />
                </button>
                <button
                  onClickRelease={() => player.next()}
                  sensitive={bind(player, "can_go_next")}
                >
                  <icon icon={"media-skip-forward"} />
                </button>
                <label
                  label={bind(player, "title").as((x) => trim_name(x, 24))}
                />
                <label label={bind(player, "artist").as((x) => `- ${x}`)} />
              </box>
            ) : (
              ""
            )}
          </box>
        );
      })}
    </box>
  );
}
