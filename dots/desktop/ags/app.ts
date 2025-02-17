#!/usr/bin/gjs -m

import { App, Widget } from "astal/gtk3";
import style from "./style.scss";
import Bar, { TopBar } from "./widgets/Bar";

App.start({
  css: style,
  icons: "./assets/icons",
  main() {
    App.get_monitors().map(Bar);
    App.get_monitors().map(TopBar);
  },
});
