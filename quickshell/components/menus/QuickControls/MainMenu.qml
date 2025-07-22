import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Qt5Compat.GraphicalEffects
import "../../../services"

GridLayout {
    id: root
    columns: 3
    rows: 3
    rowSpacing: 8
    columnSpacing: 8

    signal activateNetworkMenu
    signal activateBluetoothMenu

    component WText: Text {
        Layout.alignment: Qt.AlignCenter
        color: Theme.widget.fg
        font.pointSize: 8
    }

    SplitButton {
        toggled: !!Network.active
        onClickedRight: mouse => {
            root.activateNetworkMenu();
        }
        leftIconSource: Quickshell.iconPath(TaskbarServices.networkIcon)
    }
    SplitButton {
        toggled: Bluetooth.defaultAdapter?.enabled
        onClickedLeft: mouse => {
            const adapter = Bluetooth.defaultAdapter;
            if (!adapter) {
                return;
            }
            adapter.enabled = !adapter.enabled;
        }
        onClickedRight:{
            root.activateBluetoothMenu()
        }
        leftIconSource: Quickshell.iconPath(TaskbarServices.bluetoothIcon)
    }
    SplitButton {
        toggled: !TaskbarServices.currentAudio.muted
        onClickedLeft: mouse => {
            const audio = TaskbarServices.currentAudio;
            if (!audio) {
                return;
            }
            audio.muted = !audio.muted;
        }
        leftIconSource: Quickshell.iconPath(TaskbarServices.volumeIcon)
    }

    WText {
        text: Network.active?.ssid ?? "Loading..."
    }
    WText {
        text: {
            const devices = TaskbarServices.connectedBtDevices;
            if (devices.length == 1) {
                const device = devices[0];
                return Utils.trimText(`${device.name}`, 12);
            }
            if (devices.length > 0) {
                return `Connected: ${devices.length}`;
            }
            return "Bluetooth";
        }
    }
    WText {
        text: `Output (${Math.round(TaskbarServices.currentAudio.volume * 100)}%)`
    }

    RowLayout {
        Layout.columnSpan: 3
        implicitWidth: parent.width
        spacing: 4
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: Theme.widget.fg
            font.pointSize: 8
            text: {
                let s = TaskbarServices.currentAudioSink.nickname
                if (s.length == 0) {
                  s = TaskbarServices.currentAudioSink.description
                }
                return "TODO, List of audio sources (apps)"
            }
        }
        IconImage {
            implicitSize: 16
            source: Quickshell.iconPath(TaskbarServices.volumeIcon)

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "white"
            }
        }

        Slider {
            Layout.fillWidth: true
            from: 0
            value: TaskbarServices.currentAudio.volume
            to: 1.5
            onValueChanged: {
                TaskbarServices.currentAudio.volume = value;
            }
        }
    }
}
