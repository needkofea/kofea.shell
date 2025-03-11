import { bind, Binding, Gio, GLib, Variable } from "astal";
import { App, Gtk } from "astal/gtk4";
import Wp from "gi://AstalWp";
import { trim_name } from "../../utils";
import { Checkbox, Divider, SpinButton } from "./Others";
import { Switch } from "astal/gtk4/widget";

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

function selectSpeaker(endpoint: Wp.Endpoint | null) {
  current_speaker.set(endpoint);
}

selectSpeakerAction.connect("activate", (action, param) => {
  const playerIndex: number = param?.deep_unpack() ?? -1;
  print(`AudioControl: Selected speaker: ${playerIndex}!`);
  if (playerIndex < 0) {
    selectSpeaker(null);
    current_speaker.set(null);
    return;
  }
  selectSpeaker(audio.speakers[playerIndex]);
});

current_speaker.subscribe((endpoint) => {
  endpoint?.set_is_default(true);
});

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
            <menubutton
              cssClasses={["volume"]}
              onButtonReleased={(_, ev) => {
                console.log(ev.get_button());
                if (ev.get_button() == 3) {
                  speaker.set_mute(!speaker.mute);
                }
              }}
              onScroll={(self, x, y) => {
                speaker.volume -= Math.min(1, Math.max(y, -1)) / 100;
              }}
            >
              <popover hasArrow={false}>
                <box vertical>
                  <label
                    label={"Volume Outputs"}
                    cssClasses={["section-header"]}
                  />
                  <Divider />

                  {bind(audio, "speakers").as((x) =>
                    x.map((speaker) => {
                      return (
                        <box hexpand widthRequest={450}>
                          {/* By right should do active=bind(speaker, "isDefault") but its not really working, button keeps turning off.. anyways the the solution below works */}
                          {bind(speaker, "isDefault").as((isdefault) => (
                            <Checkbox
                              active={isdefault}
                              onButtonPressed={() =>
                                speaker.set_is_default(true)
                              }
                            />
                          ))}

                          <box widthRequest={200} halign={Gtk.Align.START}>
                            <label label={trim_name(speaker.description, 28)} />
                          </box>
                          <button
                            onClicked={(x) => speaker.set_mute(!speaker.mute)}
                          >
                            <image iconName={bind(speaker, "volumeIcon")} />
                          </button>
                          <slider
                            hexpand
                            value={bind(speaker, "volume")}
                            onChangeValue={(self) =>
                              speaker.set_volume(self.value)
                            }
                          />
                          <label
                            label={bind(speaker, "volume").as(
                              (x) => Math.round(x * 100) + "%",
                            )}
                          />
                        </box>
                      );
                    }),
                  )}
                </box>
              </popover>
              <box>
                <image iconName={bind(speaker, "volumeIcon")} />
                <label
                  cssClasses={["small"]}
                  label={bind(speaker, "volume").as(
                    (x) => Math.round(x * 100) + "%",
                  )}
                />
              </box>
            </menubutton>
          </>
        );
      })}
    </box>
  );
}
