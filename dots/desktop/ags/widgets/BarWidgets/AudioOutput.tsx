import { bind, Gio, GLib, Variable } from "astal";
import { App } from "astal/gtk4";
import Wp from "gi://AstalWp";

const audio = Wp.get_default()!!.audio;

const current_speaker = Variable<null | Wp.Endpoint>(null);
current_speaker.get()?.mute;
function select_next_output() {
  if (current_speaker.get() == null) {
    current_speaker.set(audio.get_default_speaker());
  }
}

audio.connect("speaker-removed", () => select_next_output());

select_next_output();

const selectSpeakerAction = new Gio.SimpleAction({
  name: "audio-control-select-speaker",
  parameter_type: GLib.VariantType.new("i"),
});

selectSpeakerAction.connect("activate", (action, param) => {
  const playerIndex: number = param?.deep_unpack() ?? -1;
  print(`AudioControl: Selected speaker: ${playerIndex}!`);
  if (playerIndex < 0) {
    current_speaker.set(null);
    return;
  }
  current_speaker.set(audio.speakers[playerIndex]);
});

current_speaker.subscribe((endpoint) => {
  endpoint?.set_is_default(true);
});

function trim_name(s: string, max_len: number = 32) {
  if (!s) return "";
  if (s.length > max_len) {
    return s.slice(0, max_len - 3) + "...";
  }
  return s;
}

App.add_action(selectSpeakerAction);

export function AudioOutput() {
  const avail_speakers = bind(audio, "speakers").as((speakers) => {
    let section = new Gio.Menu();
    speakers.forEach((speaker, index) => {
      let mItem = new Gio.MenuItem();
      const label = `${speaker.description}${speaker.mute ? " - Muted" : ""}`;
      mItem.set_label(label);
      mItem.set_action_and_target_value(
        "app.audio-control-select-speaker",
        GLib.Variant.new_int32(index),
      );
      section.append_item(mItem);
    });

    return section;
  });

  return (
    <box cssClasses={["audio-out"]}>
      {bind(current_speaker).as((speaker) => {
        if (!speaker) {
          return "";
        }
        return (
          <>
            <menubutton menuModel={avail_speakers}>
              <box cssClasses={["audio-out-label"]}>
                <label
                  label={bind(speaker, "description").as((x) =>
                    trim_name("    " + x, 24),
                  )}
                />
              </box>
            </menubutton>
            <box cssClasses={["volume"]}>
              <button
                onClicked={() => speaker.set_mute(!speaker.mute)}
                cssClasses={["mute-btn"]}
              >
                <image
                  iconName={bind(speaker, "mute").as((x) =>
                    x ? "audio-volume-muted" : "audio-volume-high",
                  )}
                />
              </button>

              <label
                cssClasses={["small"]}
                label={bind(speaker, "volume").as(
                  (x) => Math.round(x * 100) + "%",
                )}
              />
            </box>
          </>
        );
      })}
    </box>
  );
}
