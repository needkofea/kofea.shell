import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell

import "../services"
import "../components"

Item {
    id: root
    implicitWidth: container.width

    Rectangle {
        id: container
        color: mouse.containsMouse ? Theme.quick_controls.bg_hover : Theme.quick_controls.bg
        anchors.centerIn: parent

        property int margin: Theme.barMargin
        implicitWidth: layout.width + 18
        height: parent.height - margin

        radius: parent.height / 8

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true

            RowLayout {
                id: layout
                anchors.centerIn: parent
                height: parent.height - 20
                spacing: 8

                QcItem {

                    implicitSize: layout.height
                    source: Quickshell.iconPath(TaskbarServices.networkIcon)
                    color: "#ffffff"

                    TooltipArea {
                        anchors.fill: parent
                        text: TaskbarServices.currentNetworkTooltip
                    }
                }

                QcItem {
                    implicitSize: parent.height
                    source: Quickshell.iconPath(TaskbarServices.bluetoothIcon)
                    color: "#ffffff"

                    TooltipArea {
                        anchors.fill: parent
                        text: TaskbarServices.currentBluetoothTooltip
                    }
                }
                QcItem {
                    implicitSize: parent.height
                    source: Quickshell.iconPath(TaskbarServices.volumeIcon)
                    color: "#ffffff"
                }
            }
        }

        Behavior on color {
            ColorAnimation {}
        }
    }
}
