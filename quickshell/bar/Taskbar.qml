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
                property int dotSizeHover: 10

                property int padding: 2

                property int activeHeight: 24 + padding
                property int activeWidth: Math.max(32, activeContents.width) + padding

                property HyprlandWorkspace wsData: modelData

                property int active: wsItem.wsData.active

                implicitWidth: active ? activeWidth : dotSize
                implicitHeight: parent.height

                property color neutralColor: mouseArea.containsMouse ? Theme.workspace.hover.bg : Theme.workspace.inactive.bg

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                Rectangle {
                    anchors.centerIn: parent

                    property int enlargedDot: mouseArea.containsMouse && !wsItem.active
                    property int dotSize: enlargedDot ? wsItem.dotSizeHover : wsItem.dotSize
                    

                    implicitHeight: wsItem.active ? activeHeight : dotSize
                    implicitWidth: enlargedDot ? wsItem.dotSizeHover : parent.width

                    color: wsItem.active ? Theme.workspace.active.bg : wsItem.neutralColor
                    radius: parent.height

                    Behavior on color {
                        ColorAnimation {}
                    }
                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutSine
                        }
                    }

                    TaskbarItems {
                        id: activeContents
                        ws: wsItem.wsData
                        anchors.centerIn: parent
                        implicitHeight: wsItem.activeHeight - wsItem.padding
                        visible: wsItem.active
                        opacity: wsItem.active ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: wsItem.wsData.activate()
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
