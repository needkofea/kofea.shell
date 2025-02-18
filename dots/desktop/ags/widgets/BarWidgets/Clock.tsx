import { GLib, Variable } from "astal";

export default function Clock({ format = "%I:%M %p" }) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );

  return (
    <box className="time">
      <label onDestroy={() => time.drop()} label={time()} />
    </box>
  );
}
