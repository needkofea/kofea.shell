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

Rectangle {
    // id: root

    implicitWidth: stack?.width + 16
    implicitHeight: stack?.height + 16

    color: Theme.panel.bg
    border.color: Theme.panel.border
    radius: Theme.panel.radius

    StackView {
        id: stack
        anchors.centerIn: parent

        implicitWidth: stack.currentItem ? stack.currentItem.implicitWidth : 100
        implicitHeight: stack.currentItem ? stack.currentItem.implicitHeight : 100
        clip: true

        initialItem: viewMainMenu
    }

    Component {
        id: viewMainMenu
        MainMenu {
            onActivateNetworkMenu: () => {
                stack.push(viewNetworkMenu);
            }
            onActivateBluetoothMenu: () => {
                stack.push(viewBluetoothMenu);
            }
        }
    }

    Component {
        id: viewNetworkMenu
        NetworkMenu {
            onBackClicked: () => {
                stack.pop();
            }
        }
    }
    Component {
        id: viewBluetoothMenu
        BluetoothMenu {
            onBackClicked: () => {
                stack.pop();
            }
        }
    }

}
