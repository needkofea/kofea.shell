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

    HyprlandFocusGrab {
        id: grab
        windows: [root]
        onCleared: {
            root.active = false;
        }
    }

    onActiveChanged: {
        grab.active = root.active;
        layout.popToIndex(0);
    }

    Rectangle {
        id: ctn
        anchors.top: parent.top

        implicitWidth: layout.width + 16
        implicitHeight: layout.height + 16

        color: Theme.panel.bg
        border.color: Theme.panel.border
        radius: Theme.panel.radius

        StackView {
            id: layout
            anchors.centerIn: parent

            implicitWidth: layout.currentItem ? layout.currentItem.implicitWidth : 100
            implicitHeight: layout.currentItem ? layout.currentItem.implicitHeight : 100
            clip: true

            initialItem: viewMainMenu

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
                    layout.push(viewNetworkMenu);
                }
            }
        }

        Component {
            id: viewNetworkMenu
            NetworkMenu {
                onBackClicked: () => {
                    layout.pop();
                }
            }
        }
    }

    component NumberAnim: NumberAnimation {
        duration: 150
        easing.type: Easing.InOutQuart
    }

    Behavior on implicitHeight {
        NumberAnim {}
    }
}
