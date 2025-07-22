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

    implicitHeight: active ? (ctn.height ?? 1) : 1
    implicitWidth: ctn.width ?? 1

    anchor.rect.y: -(this.height + 8)
    anchor.adjustment: PopupAdjustment.SlideX

    visible: implicitHeight > 1
    color: "transparent"

    property bool rootAnim: true

    HyprlandFocusGrab {
        id: grab
        windows: [root]
        onCleared: {
            root.active = false;
        }
    }

    onActiveChanged: {
        grab.active = root.active;
        stack.popToIndex(0);

        // Re-enable root animation for closing
        root.rootAnim = true;
    }

    Rectangle {
        id: ctn
        anchors.top: parent.top

        implicitWidth: stack.width + 16
        implicitHeight: stack.height + 16

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

            onCurrentItemChanged: {
                // Turn off root animation to prevent double animation
                root.rootAnim = false;
            }

            Behavior on implicitWidth {
                NumberAnim {}
            }
            Behavior on implicitHeight {
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
        easing.type: Easing.OutExpo
    }

    Behavior on implicitHeight {
        enabled: root.rootAnim
        NumberAnim {}
    }
}
