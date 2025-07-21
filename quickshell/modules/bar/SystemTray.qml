pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell.Io
import Quickshell
import "../../services"

Item {
    id: root
    implicitWidth: container.width

    RowLayout {
        id: container
        anchors.centerIn: root
        spacing: 0

        Repeater {
            model: SystemTray.items
            delegate: MouseArea {
                id: item
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                required property SystemTrayItem modelData
                implicitHeight: icon.height + 8
                implicitWidth: icon.width + 8
                onClicked: event => {
                    if (event.button === Qt.LeftButton)
                        modelData.activate();
                    else if (modelData.hasMenu) {
                        const coords = item.mapToGlobal(0, -10);
                        console.log("X:" + coords.x, "Y:" + coords.y);
                        menu.anchor.rect.x = coords.x;
                        menu.anchor.rect.y = coords.y + item.height - 10;

                        console.log("X:" + menu.anchor.rect.x, "Y:" + menu.anchor.rect.y);
                        menu.open();
                    } else {
                        console.log("No menu!");
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: item.containsMouse ? Theme.system_tray.item.bg_hover : Theme.system_tray.item.bg
                    radius: parent.height / 4

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

                IconImage {
                    id: icon
                    anchors.centerIn: parent
                    implicitSize: root.height - 26
                    source: item.modelData.icon
                    z: 10
                }

                QsMenuAnchor {
                    id: menu
                    menu: item.modelData.menu
                    anchor.adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
                    anchor.window: this.QsWindow.window
                }

                // color: "transparent"

            }
        }
    }
}
