import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell

import "../../services"
import "../../components"
import "../../components/menus/QuickControls"

Item {
    id: root
    implicitWidth: container.width

    QuickControlMenu {
        id: menu
        anchor.item: root

        anchor.rect.x: -(this.width / 2)
    }

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
            onClicked: mouse => {
                if (mouse.button !== Qt.LeftButton) {
                    return;
                }
                menu.active = !menu.active;
            }

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
