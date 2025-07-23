pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import "../../../services"

PanelWindow {
    id: root

    implicitHeight: ctn.height + 16
    implicitWidth: ctn.width + 16

    screen: PanelServices.quickControlActiveScreen
    anchors {
        left: true
        bottom: true
    }
    exclusiveZone: 0
    visible: !!PanelServices.quickControlActiveScreen
    color: "transparent"

    onScreenChanged: {}

    Connections {
        target: PanelServices
        function onMouseBlocked() {
            console.log("test")
            PanelServices.closeQuickControls()
        }
    }

    focusable: true

    // onActiveChanged: {
    //     grab.active = root.active;
    //     // Re-enable root animation for closing
    //     if (root.active) {
    //         stack.popToIndex(0);
    //     }
    // }

    Component {
        id: menu
        QuickControlMenu {}
    }
    Loader {
        id: ctn
        anchors.centerIn: parent
        // Need to set to undefined to destroy loaded objects (when not visible) to prevent reuse across windows
        sourceComponent: visible ? menu : undefined
    }
    Item {
        focus: true
        anchors.fill: parent
        Keys.onPressed: ev => {
            console.log("Ev:", ev);
        }
        Keys.onEscapePressed: {
            PanelServices.closeQuickControls();
        }
    }
}
