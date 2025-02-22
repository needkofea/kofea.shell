import { bind, Gio, Variable } from "astal";
import { MenuButton } from "astal/gtk3/widget";

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

function extendTrayItemMenu(model: Gio.MenuModel) {
  return model;
}

export default function SysTray() {
  return (
    <box cssClasses={["systray"]}>
      {bind(tray, "items").as((items) =>
        items.map((item) => (
          <menubutton
            canFocus={false}
            setup={(self) => {
              self.insert_action_group("dbusmenu", item.actionGroup);
            }}
            tooltipMarkup={bind(item, "tooltipMarkup")}
            menuModel={bind(item, "menuModel").as((x) => extendTrayItemMenu(x))}
          >
            <image gicon={bind(item, "gicon")} />
          </menubutton>
        )),
      )}
    </box>
  );
}
