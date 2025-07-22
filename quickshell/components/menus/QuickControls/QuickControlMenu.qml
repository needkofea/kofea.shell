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

PopupWindow {
    id: root
    property bool active: false

    implicitHeight: ctn.height ?? 1
    implicitWidth: ctn.width ?? 1

    readonly property int activeYPos: -(this.height + 8)
    property int relY: active ? activeYPos : this.height

    anchor.rect.y: relY
    anchor.adjustment: PopupAdjustment.SlideX

    visible: true
    color: "transparent"

    Behavior on relY {

        NumberAnim {}
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]
        onCleared: {
            root.active = false;
        }
    }

    onActiveChanged: {
        grab.active = root.active;
        // Re-enable root animation for closing
        if (root.active) {
            stack.popToIndex(0);
        }
    }

    Rectangle {
        id: ctn
        anchors.top: parent.top

        implicitWidth: stack.width + 16
        implicitHeight: stack.height + 16
        opacity: root.active ? 1 : 0

        Behavior on opacity {
            NumberAnim {}
        }

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

            Behavior on implicitWidth {
                NumberAnim {}
            }
        }

        Component {
            id: viewMainMenu
            MainMenu {
                onActivateNetworkMenu: () => {
                    if (!root.active)
                        return;
                    stack.push(viewNetworkMenu);
                }
                onActivateBluetoothMenu: () => {
                    if (!root.active)
                        return;
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

    component NumberAnim: NumberAnimation {
        duration: 300
        // velocity: 200
        easing.type: Easing.OutExpo
    }
}
