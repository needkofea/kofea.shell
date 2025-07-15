import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell
import QtQuick
import "root:"

PanelWindow {
    anchors {
        bottom: true
        left: true
        right: true
    }

    color: Theme.background

    implicitHeight: 38

    WrapperItem {
        anchors.fill: parent
        leftMargin: 8
        rightMargin: 8

        Item {
            Workspaces {
                implicitHeight: parent.height
                // Layout.alignment: Qt.AlignLeft
            }
            Taskbar {
                anchors.centerIn: parent
                implicitHeight: parent.height
                // ws: Hyprland.focusedWorkspace
            }
        }
    }
}
