import { Variable } from "astal";
import Tray from "gi://AstalTray";

const tray = Tray.get_default();

// const trayItems = Variable<Tray.TrayItem[]>([]).poll(200, () => tray.items);

export default function TrayBar() {
  return <box></box>;
}
