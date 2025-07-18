import QtQuick
import QtQuick.Layouts
import Quickshell

import "../services"

Item {
    id: root
    implicitWidth: container.width

    Rectangle {
        id: container
        color: Theme.network_status.bg
        anchors.centerIn: parent

        property int margin: Theme.barMargin
        implicitWidth: layout.width + 18
        height: parent.height - margin

        radius: parent.height / 8

        RowLayout {
            id: layout
            anchors.centerIn: parent
            height: parent.height - 20
            spacing: 8

            StatusItem {
                implicitSize: parent.height
                source: Quickshell.iconPath(TaskbarServices.networkIcon)
                color: "#ffffff"
            }
            StatusItem {
                implicitSize: parent.height
                source: Quickshell.iconPath(TaskbarServices.bluetoothIcon)
                color: "#ffffff"
            }
            StatusItem {
                implicitSize: parent.height
                source: Quickshell.iconPath(TaskbarServices.volumeIcon)
                color: "#ffffff"
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }

        Behavior on color {
            ColorAnimation {}
        }
    }
}
