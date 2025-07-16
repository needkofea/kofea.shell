import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick
import "../services"
import ".."

PanelWindow {
    id: window
    anchors {
        bottom: true
        left: true
        right: true
    }

    color: Theme.background

    implicitHeight: 38

    property HyprlandMonitor monitor: Hyprland.monitorFor(window.screen)
    WrapperItem {
        anchors.fill: parent
        leftMargin: 8
        rightMargin: 8

        Item {
            property var workspaces: Hyprland.workspaces.values.filter(x => x.monitor.id == window.monitor.id)
            
            Workspaces {
                implicitHeight: parent.height
                workspaces: parent.workspaces
                // Layout.alignment: Qt.AlignLeft
            }
            Taskbar {
                monitor: window.monitor
                anchors.centerIn: parent
                implicitHeight: parent.height
                // ws: Hyprland.focusedWorkspace
            }
        }
    }
}
