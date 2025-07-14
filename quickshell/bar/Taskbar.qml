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
        spacing: 4

        Repeater {
            id: list
            model: Hyprland.workspaces
            delegate: Item {
                id: wsItem
                property int dotSize: 8
                property int dotSizeHover: 10

                property int padding: 2

                property int activeHeight: 24 + padding
                property int activeWidth: Math.max(24, activeContents.width) + padding

                property HyprlandWorkspace wsData: modelData

                property int haveClients: wsData.toplevels.values.length > 0
                property int active: wsItem.wsData.active

                implicitWidth: haveClients ? activeWidth : dotSize
                implicitHeight: parent.height

                property color neutralColor: {
                    if (mouseArea.containsMouse) {
                        return Theme.workspace.hover.bg;
                    }
                    if (haveClients) {
                        return Theme.workspace.inactive.noitems_bg;
                    }
                    return Theme.workspace.inactive.bg;
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                Rectangle {
                    anchors.centerIn: parent

                    property int enlargedDot: mouseArea.containsMouse && !haveClients
                    property int dotSize: enlargedDot ? wsItem.dotSizeHover : wsItem.dotSize

                    implicitHeight: wsItem.haveClients ? activeHeight : dotSize
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
                        opacity: wsItem.haveClients ? 1 : 0
                        visible: wsItem.haveClients
                        minimised: !wsItem.active && wsItem.haveClients

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
