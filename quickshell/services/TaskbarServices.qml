pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    property bool mirrorTaskbar: false
    property bool alwaysExpandWsGroup: true
    readonly property list<DesktopEntry> list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))

    // Returns a list of workspace ids for the taskbar for the current monitor
    function getWorkspaces(monitor) {
        if (Hyprland.monitors == 1 || mirrorTaskbar) {
            let arr = [];
            let max_id = Hyprland.workspaces.values[Hyprland.workspaces.values.length - 1].id;
            for (let i = 0; i < max_id; i++) {
                arr.push(i + 1);
            }
            return arr;
        }

        // let arr = [];
        // for (let i = 0; i < length; i++) {
        //     arr.push(i);
        // }
        return Hyprland.workspaces.values.filter(x => x.monitor?.id == monitor?.id).map(x => x?.id);
    }

    function findEntryBestEffort(appid, title) {
        const maybe = DesktopEntries.byId(appid);
        if (maybe) {
            return maybe;
        }

        let bestEffort = DesktopEntries.applications.values.find(x => x.id.toLowerCase().includes(appid.toLowerCase()));
        if (!bestEffort){
            bestEffort = DesktopEntries.applications.values.find(x => x.name.toLowerCase().includes(title.toLowerCase()));
        }
        console.log(`Using best effort for (title: ${title}; id: ${appid}) -> ${bestEffort?.id}`)
        return bestEffort
    }

    function iconPath(icon_source: string): string {
        if (icon_source.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
        }
        return Quickshell.iconPath(icon_source);
    }

    property BluetoothAdapter bluetoothAdapter: Bluetooth.defaultAdapter
    property string bluetoothIcon: {
        // const x = bluetoothDevice?.icon ?? "bluetooth-hardware-disabled-symbolic";

        if (!bluetoothAdapter) {
            return "bluetooth-hardware-disabled-symbolic";
        }

        if (!bluetoothAdapter.enabled) {
            return "bluetooth-disabled-symbolic";
        }

        if (bluetoothAdapter.discovering) {
            return "bluetooth-acquiring-symbolic";
        }

        if (bluetoothAdapter.devices?.values?.length == 0) {
            return "bluetooth-disconnected-symbolic";
        }

        return "bluetooth-active-symbolic";
    }

    property string networkIcon: getNetworkIcon(Network.active?.strength)

    function getNetworkIcon(strength: int): string {
        if (strength == null) {
            return "network-wireless-offline-symbolic";
        }
        if (strength > 80)
            return "network-wireless-signal-excellent-symbolic";
        if (strength > 60)
            return "network-wireless-signal-good-symbolic";
        if (strength > 40)
            return "network-wireless-signal-ok-symbolic";
        if (strength > 20)
            return "network-wireless-signal-weak-symbolic";
        return "network-wireless-signal-none-symbolic";
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSink.audio]
    }

    property bool audioReady: Pipewire.defaultAudioSink.ready
    property PwNodeAudio currentAudio: Pipewire.defaultAudioSink.audio

    property string volumeIcon: {
        if (!audioReady) {
            return "content-loading-symbolic";
        }
        if (currentAudio.muted) {
            return "audio-volume-muted-symbolic";
        }
        if (currentAudio.volume > .75) {
            return "audio-volume-high-symbolic";
        }
        if (currentAudio.volume > .4) {
            return "audio-volume-medium-symbolic";
        }
        if (currentAudio.volume > 0) {
            return "audio-volume-low-symbolic";
        }
        return "audio-volume-muted-symbolic";
    }
}
