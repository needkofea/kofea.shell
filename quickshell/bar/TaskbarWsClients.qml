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
        spacing: 0

        Repeater {
            model: taskbar.ws.toplevels

            delegate: Item {
                id: taskbarItem

                property HyprlandToplevel topLevel: modelData
                height: parent.height
                implicitWidth: Math.max(wsClients.width, taskbarItem.height) + 8

                Rectangle {
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? Theme.taskbar.item.hover.bg : Theme.taskbar.item.normal.bg
                    radius: parent.height / 4
                    border.color: mouseArea.containsMouse ? Theme.border : "transparent"
                }

                RowLayout {
                    id: wsClients
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: parent.height
                    spacing: 4
                    Rectangle {
                        color: "transparent"
                        property int size: parent.height - 4
                        implicitHeight: size
                        implicitWidth: size
                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: parent.size
                            source: "reallyBigImage.svg"
                        }
                    }

                    Text {
                        property int max_len: 24
                        property string trimmedText: taskbarItem.topLevel.title.length > max_len ? taskbarItem.topLevel.title.slice(0, max_len - 3) + "..." : taskbarItem.topLevel.title
                        text: trimmedText
                        font.weight: 500
                        color: mouseArea.containsMouse ? Theme.taskbar.item.hover.fg : Theme.taskbar.item.normal.fg
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
