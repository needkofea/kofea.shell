pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property bool mirrorTaskbar: false
    readonly property list<DesktopEntry> list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))

    // Returns a list of workspace ids for the taskbar for the current monitor
    function getWorkspaces(monitor) {
        if (Hyprland.monitors == 1 || mirrorTaskbar) {
            let arr = [];
            let max_id = Hyprland.workspaces.values[Hyprland.workspaces.values.length-1].id
            for (let i = 0; i < max_id; i++) {
                arr.push(i + 1);
            }
            return arr;
        }

        // let arr = [];
        // for (let i = 0; i < length; i++) {
        //     arr.push(i);
        // }
        return Hyprland.workspaces.values.filter(x => x.monitor.id == monitor.id).map(x=>x.id);
    }
}
