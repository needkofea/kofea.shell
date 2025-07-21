import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import "../../services"

Item {
    id: root
    width: childrenRect.width

    required property var workspaces

    RowLayout {
        height: parent.height

        Repeater {
            id: list
            model: root.workspaces
            delegate: Item {
                id: rect
                property int size: 8
                property int activeSize: 18
                required property HyprlandWorkspace modelData

                implicitWidth: modelData.active ? Math.max(32, label.width + 18) : size
                implicitHeight: activeSize + 4

                property color neutralColor: mouseArea.containsMouse ? Theme.workspace.hover.bg : Theme.workspace.inactive.bg

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    implicitHeight: modelData.active ? activeSize : size
                    color: modelData.active ? Theme.workspace.active.bg : neutralColor
                    radius: parent.height

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: 450
                    font.pixelSize: 12
                    text: modelData.name
                    visible: modelData.active
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: modelData.activate()
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.Bezier
                    }
                }
                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutElastic
                    }
                }
            }
        }
    }
}
