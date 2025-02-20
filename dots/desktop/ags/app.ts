import { App, Gtk, Widget } from "astal/gtk4";
import style from "./style.scss";
import Bar, { TopBar } from "./widgets/Bar";

import { readGtkTheme } from "./utils";
import { KofeaApi } from "./api";

App.start({
  css: style,
  icons: "./assets/icons",
  gtkTheme: readGtkTheme() ?? undefined,
  main() {
    KofeaApi.PinnedApps.refresh();
    App.get_monitors().map(Bar);
    App.get_monitors().map(TopBar);
  },
});
