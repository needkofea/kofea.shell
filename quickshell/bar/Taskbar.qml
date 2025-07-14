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
        spacing: 8
        Repeater {
            id: list
            model: Hyprland.workspaces
            delegate: Item {
                id: wsItem
                property int dotSize: 8
                property int dotSizeHover: 16

                property int padding: 2

                property int activeHeight: 24 + padding
                property int activeWidth: Math.max(32, activeContents.width) + padding

                property HyprlandWorkspace wsData: modelData

                implicitWidth: wsItem.wsData.active ? activeWidth : dotSize
                implicitHeight: parent.height

                property color neutralColor: mouseArea.containsMouse ? Theme.workspace.hover.bg : Theme.workspace.inactive.bg

                Rectangle {
                    anchors.centerIn: parent

                    property int enlargedDot: mouseArea.containsMouse && !wsItem.wsData.active
                    property int dotSize: enlargedDot ? wsItem.dotSizeHover : wsItem.dotSize

                    implicitHeight: wsItem.wsData.active ? activeHeight : dotSize
                    implicitWidth: enlargedDot ? wsItem.dotSizeHover : parent.width

                    color: wsItem.wsData.active ? Theme.workspace.active.bg : wsItem.neutralColor
                    radius: parent.height

                    Behavior on color {
                        ColorAnimation {}
                    }

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.Linear
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
                    implicitHeight: wsItem.activeHeight - wsItem.padding
                    visible: wsItem.wsData.active
                    TaskbarWsClients {
                        ws: wsItem.wsData
                    }
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }
    }
}
