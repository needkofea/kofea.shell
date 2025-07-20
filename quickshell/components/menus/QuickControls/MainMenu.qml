import QtQuick
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
    rowSpacing: 3
    columnSpacing: 8

    signal activateNetworkMenu

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
        leftIconSource: Quickshell.iconPath(TaskbarServices.bluetoothIcon)
    }
    ToggleButton {}
    WText {
        text: Network.active?.ssid ?? "Loading..."
    }
    WText {
        text: {
            const devices = TaskbarServices.connectedBtDevices;
            if (devices.length == 1) {
                const device = devices[0];
                const maxLen = 12;
                if (device.name.length > maxLen) {
                    return device.name.slice(0, maxLen - 3) + "...";
                }
                return device.name;
            }
            if (devices.length > 0) {
                return `Connected: ${devices.length}`;
            }
            return "Bluetooth";
        }
    }
    WText {
        text: "Microphone"
    }
}
