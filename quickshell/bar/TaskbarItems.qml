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
    required property bool minimised

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
                implicitWidth: Math.max(wsClient.width, taskbarItem.height) + 10

                Rectangle {
                    anchors.fill: parent
                    color: {
                        if (mouseArea.containsMouse)
                            return Theme.taskbar.item.hover.bg;
                        if (topLevel.activated)
                            return Theme.taskbar.item.active.bg;
                        return Theme.taskbar.item.normal.bg;
                    }
                    radius: parent.height
                    border.color: mouseArea.containsMouse ? Theme.border : "transparent"

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

                RowLayout {
                    id: wsClient
                    anchors.centerIn: parent
                    height: parent.height
                    spacing: 4

                    property string appId: taskbarItem.topLevel.wayland?.appId ?? ''
                    property DesktopEntry entry: DesktopEntries.byId(appId)
                    Rectangle {
                        color: "transparent"
                        property int iconSize: parent.height - 4
                        implicitHeight: iconSize
                        implicitWidth: iconSize
                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: parent.iconSize
                            source: Quickshell.iconPath(wsClient.entry.icon)
                        }
                    }

                    WrapperItem {
                        rightMargin: 4

                        visible: !taskbar.minimised
                        Text {
                            property int max_len: 24
                            property bool loaded: taskbarItem.topLevel.title !== wsClient.appId
                            property string label: loaded ? taskbarItem.topLevel.title : ''
                            property string trimmedText: label.length > max_len ? label.slice(0, max_len - 3) + "..." : label
                            text: trimmedText
                            font.weight: 500
                            color: {
                                if (mouseArea.containsMouse) {
                                    return Theme.taskbar.item.hover.fg;
                                }
                                if (topLevel.activated) {
                                    return Theme.taskbar.item.active.fg;
                                }
                                return Theme.taskbar.item.normal.fg;
                            }
                            Behavior on color {
                                ColorAnimation {}
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.Linear
                            }
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
