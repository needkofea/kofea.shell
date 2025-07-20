import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import Qt5Compat.GraphicalEffects
import "../../../services"

ColumnLayout {
    id: layout

    signal backClicked
    spacing: 6
    RowLayout {
        spacing: 8

        IconImage {
            implicitSize: 16
            source: Quickshell.iconPath("pan-start-symbolic")
            MouseArea {
                anchors.fill: parent
                onClicked: () => {
                    layout.backClicked();
                }
            }
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "white"
            }
        }

        Text {
            text: "Wi-Fi"
            color: "white"
            font.pointSize: 10
        }
    }

    ScrollView {

        implicitHeight: 400
        implicitWidth: layout2.width

        ColumnLayout {
            id: layout2
            Repeater {
                id: repeater
                property var selected: null

                model: Network.networks
                delegate: Item {
                    implicitWidth: child.width
                    implicitHeight: child.height
                    NetworkMenuItem {
                        id: child
                        name: modelData.ssid.length > 0 ? modelData.ssid : "No SSID"
                        desc: `${modelData.frequency / 1000} Ghz`
                        label: modelData.active ? "Disconnect" : "Connect"
                        expanded: repeater.selected == child

                        onClicked: {
                            console.error("WIP");
                            // Waiting for proper NetworkManager support from Quickshell or until I find one sufficiently good
                        }
                        onToggleExpanded: {
                            repeater.selected = child;
                        }
                    }
                }
            }
        }
    }
}
