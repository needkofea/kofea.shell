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

    implicitWidth: childrenRect.width

    // Text{
    //     color: "white"
    //     text: taskbar.ws.id
    // }

    RowLayout {
        height: parent.height
        spacing: 0

        Repeater {
            model: taskbar.ws.toplevels

            delegate: Item {
                id: taskbarItem

                property HyprlandToplevel topLevel: modelData
                height: parent.height
                implicitWidth: Math.max(wsClients.width, taskbarItem.height) + 10

                Rectangle {
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? Theme.taskbar.item.hover.bg : Theme.taskbar.item.normal.bg
                    radius: parent.height
                    border.color: mouseArea.containsMouse ? Theme.border : "transparent"
                }

                RowLayout {
                    id: wsClients
                    anchors.centerIn: parent
                    height: parent.height
                    spacing: 4

                    property DesktopEntry entry: DesktopEntries.byId(taskbarItem.topLevel.wayland?.appId)
                    Rectangle {
                        color: "transparent"
                        property int iconSize: parent.height - 4
                        implicitHeight: iconSize
                        implicitWidth: iconSize
                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: parent.iconSize
                            source: Quickshell.iconPath(wsClients.entry.icon)
                        }
                    }

                    WrapperItem {
                        rightMargin: 4
                        Text {
                            property int max_len: 24
                            property string label: taskbarItem.topLevel.title
                            property string trimmedText: label.length > max_len ? label.slice(0, max_len - 3) + "..." : label
                            text: trimmedText
                            font.weight: 500
                            color: mouseArea.containsMouse ? Theme.taskbar.item.hover.fg : Theme.taskbar.item.normal.fg
                        }
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


}
