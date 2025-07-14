pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property var clients: groupBy(Hyprland.toplevels.values, x => x.workspace.id)

}
