import Quickshell.Bluetooth
import Quickshell

NetworkMenuItem {
    id: root

    required property BluetoothDevice btDevice
    property bool _expanded
    name: btDevice.name
    iconSource: {
        if (btDevice.icon)
            return Quickshell.iconPath(btDevice.icon + "-bluetooth-symbolic");
        return Quickshell.iconPath("bluetooth-symbolic");
    }
    colorised: true
    desc: {
        let s = "";

        if (btDevice.state == BluetoothDeviceState.Disconnecting) {
            s = "Disconnecting...";
        }
        if (btDevice.state == BluetoothDeviceState.Disconnected) {
            s = "Disconnected";
        }
        if (btDevice.state == BluetoothDeviceState.Connected) {
            s = "Connected";
        }
        if (btDevice.state == BluetoothDeviceState.Connecting) {
            s = "Connecting...";
        }

        if (btDevice.batteryAvailable) {
            s += ` (🔋${Math.round(btDevice.battery * 100)}%)`;
        }
        return s;
    }
    label: btDevice.connected ? "Disconnect" : "Connect"
    expanded: root._expanded
    disableBtn: btDevice.state == BluetoothDeviceState.Disconnecting || btDevice.state == BluetoothDeviceState.Connecting
    onClicked: {
        if (btDevice.state == BluetoothDeviceState.Disconnecting) {
            return;
        }
        if (btDevice.state == BluetoothDeviceState.Disconnected) {
            btDevice.connect();
            return;
        }
        if (btDevice.state == BluetoothDeviceState.Connected) {
            btDevice.disconnect();
            return;
        }
        if (btDevice.state == BluetoothDeviceState.Connecting) {
            return;
        }
    }
    onToggleExpanded: {
        root._expanded = !root._expanded;
    }
}
