import { App, Gtk, Widget } from "astal/gtk4";
import style from "./style.scss";
import Bar, { TopBar } from "./widgets/Bar";

import { readGtkTheme } from "./utils";
import { KofeaApi } from "./api";
import AppSwitcher, { appswitcherActive } from "./widgets/AppSwitcher";

App.start({
  css: style,
  icons: "./assets/icons",
  gtkTheme: readGtkTheme() ?? undefined,

  main() {
    KofeaApi.register_global_actions();
    KofeaApi.PinnedApps.refresh();
    App.get_monitors().map(Bar);
    App.get_monitors().map(TopBar);
    App.get_monitors().map(AppSwitcher);
  },

  requestHandler(request: string, res: (response: any) => void) {
    if (request == "appswitcher-enable") {
      appswitcherActive.set(true);
    } else if (request == "appswitcher-disable") {
      appswitcherActive.set(false);
    } else {
      return res("Unnknown command!");
    }

    return res("");
  },
});
