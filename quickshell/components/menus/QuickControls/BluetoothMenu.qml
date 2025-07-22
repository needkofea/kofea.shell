import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth

import Qt5Compat.GraphicalEffects
import "../../../services"
import "../.."

ColumnLayout {
    id: root

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
                    root.backClicked();
                    console.log("Bluetooth: Stop scanning for devices (Reason: Exited menu)");
                    Bluetooth.defaultAdapter.discovering = false;
                }
            }
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "white"
            }
        }

        Text {
            text: "Bluetooth Devices"
            color: "white"
            font.pointSize: 10
        }
    }

    ScrollView {

        implicitHeight: 400
        implicitWidth: layout2.width

        ColumnLayout {
            id: layout2

            property list<BluetoothDevice> knownDevices: Bluetooth.devices.values.filter(x => x.trusted || x.paired)

            Text {
                color: Theme.widget.fg
                text: `Known Devices (${parent.knownDevices.length})`
            }
            Repeater {
                id: connectedDevices
                property var selected: null

                model: parent.knownDevices
                delegate: Item {
                    id: child
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                    BtDeviceItem {
                        btDevice: modelData
                    }
                }
            }

            RowLayout {
                implicitWidth: parent.width
                Text {
                    color: Theme.widget.fg
                    text: "Available"
                    Layout.fillWidth: true
                }
                WButton {
                    implicitHeight: 24
                    // disabled: Bluetooth.defaultAdapter.discovering
                    text: Bluetooth.defaultAdapter.discovering ? "Stop Scan" : "Scan"
                    onClicked: mouse => {
                        if (!Bluetooth.defaultAdapter)
                            return;

                        if (Bluetooth.defaultAdapter.discovering) {
                            Bluetooth.defaultAdapter.discovering = false;
                            btScanTimeout.stop();
                            console.log("Bluetooth: Stop searching for devices (User cancelled)");
                            return;
                        }
                        console.log("Bluetooth: Searching for devices");
                        Bluetooth.defaultAdapter.enabled = true;
                        Bluetooth.defaultAdapter.discovering = true;
                        btScanTimeout.start();
                    }
                }

                Timer {
                    id: btScanTimeout
                    interval: 8000 // Scan duration
                    onTriggered: {
                        console.log("Bluetooth: Stop scanning for devices");
                        Bluetooth.defaultAdapter.discovering = false;
                    }
                }
            }

            Repeater {
                id: discoveredDevices
                property var selected: null

                model: Bluetooth.devices.values.filter(x => !(x.trusted || x.paired))
                delegate: Item {
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                    BtDeviceItem {

                        btDevice: modelData
                    }
                }
            }
        }
    }
}
