import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell
import ".."
import "../services"

Item {
    id: taskbar
    required property HyprlandWorkspace ws
    height: parent.height

    implicitWidth: childrenRect.width

    // Text{
    //     color: "white"
    //     text: taskbar.ws.id
    // }

    RowLayout {
        height: parent.height
        spacing: 4

        Repeater {
            model: taskbar.ws.toplevels

            delegate: Item {
                id: taskbarItem

                property HyprlandToplevel topLevel: modelData
                height: parent.height
                implicitWidth: Math.max(wsClients.width + 16, taskbarItem.height)

                Rectangle {
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? "black" : Theme.taskbar.item.normal.bg
                    radius: parent.height / 4
                }

                RowLayout {
                    id: wsClients
                    anchors.centerIn: parent
                    height: parent.height
                    Text {
                        text: taskbarItem.topLevel.title
                        color: Theme.taskbar.item.normal.fg
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onClicked: {
                        Hyprland.dispatch("focuswindow address:0x" + taskbarItem.topLevel.address);
                    }
                }
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 100
            easing.type: Easing.Bezier
        }
    }
}
