import { bind, register, Variable } from "astal";
import { App, Astal, Gdk, Gtk } from "astal/gtk3";
import Mpris from "gi://AstalMpris";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";
import GObject from "gi://GObject?version=2.0";

const allplayers = Mpris.Mpris.new();

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
  current_player.set(allplayers.players[playerIndex]);
});

App.add_action(selectPlayerAction);
console.log(App.action_group);

export default function MediaControl() {
  const avail_players = bind(allplayers, "players").as((players) => {
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
                <label
                  label={player ? `   ${player?.entry}` : "No player selected"}
                />
              </box>
            </menubutton>

            {player ? (
              <box className={"controls"}>
                <button onClickRelease={() => player.play_pause()}>
                  <icon
                    icon={bind(player, "playback_status").as((x) =>
                      x == Mpris.PlaybackStatus.PLAYING
                        ? "media-playback-pause"
                        : "media-playback-start",
                    )}
                  />
                </button>

                <label
                  label={player ? `${player.title} -  ${player?.artist}` : ""}
                />
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
