import { bind, Variable } from "astal";

import Tray from "gi://AstalTray";

const tray = Tray.get_default();

let last_hash = "";
const trayItems_ = Variable<Tray.TrayItem[]>([]).poll(200, () =>
  tray.get_items(),
);

const trayItems = Variable<Tray.TrayItem[]>([]);
trayItems_.subscribe((items) => {
  if (items.length < 1) return;
  let hash = items.map((x) => x.id).reduce((a, b) => a + b);
  if (last_hash != hash) {
    trayItems.set(items);
    last_hash = hash;
  }
});
export default function SysTray() {
  return (
    <box className={"systray"}>
      {bind(tray, "items").as((items) =>
        items.map((item) => (
          <menubutton
            tooltipMarkup={bind(item, "tooltipMarkup")}
            usePopover={false}
            actionGroup={bind(item, "actionGroup").as((ag) => ["dbusmenu", ag])}
            menuModel={bind(item, "menuModel")}
          >
            <icon gicon={bind(item, "gicon")} />
          </menubutton>
        )),
      )}
    </box>
  );
}
