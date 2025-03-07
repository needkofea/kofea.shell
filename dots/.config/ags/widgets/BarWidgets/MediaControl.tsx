import { bind, Binding, exec, register, Variable } from "astal";
import { App, Astal, astalify, ConstructProps, Gdk, Gtk } from "astal/gtk4";
import Mpris from "gi://AstalMpris";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";
import GObject from "gi://GObject?version=2.0";
import {
  find_app_by_wmclass,
  iconName_asFile,
  iconName_asIcon,
  trim_name,
} from "../../utils";
import Wp from "gi://AstalWp";
import { KofeaApi } from "../../api";

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

function players_ordered_by_preference(): Mpris.Player[] {
  const default_weight = 100;
  // The bigger the weight, the more preferred the player is.
  const preference_weights: Record<string, number> = {
    spotify: 200,
  };

  function get_weight(player: Mpris.Player): number {
    return preference_weights[player.get_entry()] ?? default_weight;
  }

  return [...mpris.players].sort((a, b) => get_weight(a) - get_weight(b));
}

/**
 * Automatically selects the next player if current_player is yeeted.
 */
function autoselect_next_player() {
  if (mpris.players.length > 0) {
    current_player.set(
      players_ordered_by_preference()[mpris.players.length - 1],
    );
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

const avail_players = bind(mpris, "players").as((players) => {
  return players;
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

  // return section;
});

const Divider = astalify<Gtk.Separator, Gtk.Separator.ConstructorProps>(
  Gtk.Separator,
);
export function SelectMediaPopup() {
  const audio = Wp.get_default()!.audio;

  return (
    <popover has_arrow={false} widthRequest={400}>
      <box vertical cssClasses={["select-media-popup"]}>
        <label label={"Select Player"} cssClasses={["section-header"]} />
        <Divider />
        {avail_players.as((x) =>
          x.map((p, index) => {
            const icon = find_app_by_wmclass(p.entry, KofeaApi._apps)?.iconName;

            return (
              <button
                setup={(self) => {
                  self.set_action_name("app.media-control-select-player");
                  self.set_action_target_value(GLib.Variant.new_int32(index));
                }}
              >
                <box cssClasses={["media-player-item"]}>
                  <box widthRequest={86}>
                    <image
                      cssClasses={["media-player-item-icon"]}
                      iconName={iconName_asIcon(icon)}
                      file={iconName_asFile(icon)}
                    />
                    <label
                      label={bind(p, "entry").as((s) => trim_name(s, 8))}
                      cssClasses={["media-player-item-title"]}
                    />
                  </box>

                  <label
                    label={trim_name(`${p.title} - ${p.artist}`, 45)}
                    halign={Gtk.Align.START}
                  />
                </box>
              </button>
            );
          }),
        )}
        <label label={"Volume Mixer"} cssClasses={["section-header"]} />
        <Divider />
        {bind(audio, "streams").as((x) =>
          x.map((stream) => {
            const icon = find_app_by_wmclass(
              stream.description,
              KofeaApi._apps,
            )?.iconName;

            return (
              <box cssClasses={["volume-mixer-item"]} hexpand>
                <box widthRequest={140}>
                  <image
                    cssClasses={["volume-mixer-item-icon"]}
                    iconName={iconName_asIcon(icon)}
                    file={iconName_asFile(icon)}
                  />
                  <label label={bind(stream, "name")} />
                </box>
                <slider
                  hexpand
                  onChangeValue={(self) => stream.set_volume(self.value)}
                  value={bind(stream, "volume")}
                />
              </box>
            );
          }),
        )}
      </box>
    </popover>
  );
}

export default function MediaControl() {
  return (
    <box cssClasses={["media-control"]}>
      {bind(current_player).as((player) => {
        return (
          <box>
            <menubutton
              cssClasses={["player-select-btn"]}
              halign={Gtk.Align.START}
              direction={Gtk.ArrowType.UP}
              // menuModel={avail_players}
            >
              <SelectMediaPopup />

              <box cssClasses={["media-control-player"]}>
                <label
                  label={player ? `${player?.entry}` : "No player selected"}
                />
              </box>
            </menubutton>

            {player ? (
              <box cssClasses={["controls"]}>
                <button
                  onClicked={() => player.previous()}
                  sensitive={bind(player, "can_go_previous")}
                >
                  <image iconName={"media-skip-backward"} />
                </button>
                <button onClicked={() => player.play_pause()}>
                  <image
                    iconName={bind(player, "playback_status").as((x) =>
                      x == Mpris.PlaybackStatus.PLAYING
                        ? "media-playback-pause"
                        : "media-playback-start",
                    )}
                  />
                </button>
                <button
                  onClicked={() => player.next()}
                  sensitive={bind(player, "can_go_next")}
                >
                  <image iconName={"media-skip-forward"} />
                </button>
                <label
                  label={bind(player, "title").as((x) => trim_name(x, 24))}
                />
                <label
                  label={bind(player, "artist").as((x) => `- ${x}`)}
                  cssClasses={["artist-label"]}
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
