import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import "root:"

Item {
    id: root
    width: childrenRect.width
    RowLayout {
        height: parent.height

        Repeater {
            id: list
            model: Hyprland.workspaces
            delegate: Item {
                id: wsItem
                property int size: 10
                property int activeSize: 24

                property int padding: 2

                property int activeHeight: activeSize + padding
                property int activeWidth: Math.max(32, activeContents.width) + padding

                property HyprlandWorkspace wsData: modelData

                implicitWidth: wsItem.wsData.active ? activeWidth : size
                implicitHeight: activeHeight

                property color neutralColor: mouseArea.containsMouse ? Theme.workspace.hover.bg : Theme.workspace.inactive.bg

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: wsItem.wsData.active ? activeHeight : size
                    implicitWidth: parent.width

                    color: wsItem.wsData.active ? Theme.workspace.active.bg : neutralColor
                    radius: parent.height / 4

                    Behavior on color {
                        ColorAnimation {}
                    }

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutExpo
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: wsItem.wsData.activate()
                    propagateComposedEvents: true
                }

                RowLayout {
                    id: activeContents
                    anchors.centerIn: parent
                    implicitHeight: parent.height - padding
                    opacity: wsItem.wsData.active ? 1 : 0
                    TaskbarWsClients {
                        ws: wsItem.wsData
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutExpo
                    }
                }
            }
        }
    }
}
