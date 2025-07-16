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
    required property bool expanded
    required property int padding

    implicitWidth: items.width

    // Text{
    //     color: "white"
    //     text: taskbar.ws.id
    // }

    property Item highlightTarget

    Rectangle {
        visible: taskbar.highlightTarget != undefined && taskbar.expanded

        x: taskbar.highlightTarget?.x ?? 0
        width: taskbar.highlightTarget?.width ?? 0
        height: parent.height

        color: {
            if (taskbar.highlightTarget != undefined)
                return Theme.taskbar.item.active.bg;

            return Theme.taskbar.item.normal.bg;
        }
        radius: parent.height / 4

        Behavior on color {
            ColorAnimation {}
        }

        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    RowLayout {
        id: items
        height: parent.height
        spacing: 4

        Repeater {
            model: taskbar.ws.toplevels

            delegate: Item {
                id: taskbarItem

                property HyprlandToplevel topLevel: modelData
                height: parent.height
                property int padding: taskbar.expanded ? 12 : 0
                implicitWidth: Math.max(wsClient.width, taskbarItem.height) + padding

                Component.onCompleted: {
                    setHighlightTarget();
                }
                Connections {
                    target: taskbarItem.topLevel
                    function onActivatedChanged(e) {
                        taskbarItem.setHighlightTarget();
                    }
                }

                function setHighlightTarget() {
                    if (topLevel.activated) {
                        taskbar.highlightTarget = taskbarItem;
                        return;
                    }
                }

                Rectangle {
                    anchors.centerIn: parent

                    opacity: mouseArea.containsMouse ? 1 : 0
                    color: Theme.taskbar.item.hover.bg
                    border.color: Theme.border

                    height: parent.height
                    width: Math.max(parent.height, parent.width)
                    radius: parent.height / 4

                    Behavior on opacity {
                        NumberAnimation {}
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
                            implicitSize: parent.iconSize * 1.5
                            scale: 1 / 1.5
                            mipmap: true
                            source: Quickshell.iconPath(wsClient.entry.icon)
                        }
                    }

                    WrapperItem {
                        rightMargin: 4

                        visible: taskbar.expanded
                        // width: taskbar.expanded ? childrenRect.width : 0

                        Text {
                            property int max_len: 24
                            property bool loaded: taskbarItem.topLevel.title !== wsClient.appId
                            property string label: loaded ? taskbarItem.topLevel.title : ''
                            property string trimmedText: label.length > max_len ? label.slice(0, max_len - 3) + "..." : label
                            text: trimmedText
                            font.weight: 500
                            color: {
                                if (taskbar.highlightTarget == taskbarItem) {
                                    return Theme.taskbar.item.active.fg;
                                }
                                if (mouseArea.containsMouse) {
                                    return Theme.taskbar.item.hover.fg;
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
                    enabled: taskbar.expanded
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
