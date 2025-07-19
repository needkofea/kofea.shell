// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property int barMargin: 8

    property color accent: "#1100ff"

    property color bright: Qt.hsla(accent.hslHue, 0.4, 0.85, 1)
    property color black: Qt.hsla(accent.hslHue - 0.05, 0.1, 0.1, 1)

    property color border: Qt.hsla(0, 0, 1, 0.3)

    property color background: root.black

    property var workspace: QtObject {
        property var inactive: QtObject {
            property color bg: Qt.hsla(root.black.hslHue, 0.05, 0.25, 1)
            property color noitems_bg: "transparent"
        }

        property var active: QtObject {
            property color bg: root.bright
        }

        property var hover: QtObject {
            property color bg: Qt.hsla(root.bright.hslHue, root.bright.hslSaturation, root.bright.hslLightness, 0.5)
        }
    }

    property var taskbar: QtObject {
        property var item: QtObject {
            property var active: QtObject {
                property color fg: root.black
                property color bg: Qt.hsla(root.bright.hslHue, root.bright.hslSaturation, .8, 1)
            }
            property var normal: QtObject {
                property color fg: root.bright
                property color bg: "transparent"
            }
            property var hover: QtObject {
                property color fg: root.bright
                property color bg: Qt.hsla(root.black.hslHue, 0, .8, 0.3)
            }
        }

        property var ws_group: QtObject {
            property var inactive: QtObject {
                property color bg: Qt.hsla(root.bright.hslHue, root.bright.hslSaturation, .5, 0.1)
                property color border: Qt.hsla(root.bright.hslHue, root.bright.hslSaturation, 0.8, 0.2)
                property color no_items: Qt.hsla(root.black.hslHue, root.black.hslSaturation, 0.15, 1)
            }

            property var active: QtObject {
                property color bg: Qt.hsla(root.black.hslHue, root.black.hslSaturation, 0.5, 1)
                property color no_items: root.bright
            }

            property var hover: QtObject {
                property color border: Qt.hsla(root.bright.hslHue, root.bright.hslSaturation, root.bright.hslLightness, 0.2)
                
            }
        }
    }

    property var clock: QtObject {
        property color bg: Qt.hsla(root.black.hslHue, 0.2, 0.3, 1)
        property color bg_hover: Qt.hsla(bg.hslHue, bg.hslSaturation, bg.hslLightness + 0.1, 1)
        property color fg: "white"
        property color date_fg: Qt.hsla(root.bright.hslHue, root.bright.hslSaturation, .9, 1)
    }

    property var system_tray: QtObject {
        property var item: QtObject {
            property color bg: "transparent"
            property color bg_hover: Qt.hsla(root.black.hslHue, 0.1, 0.3, 1)
        }
    }

    property var network_status: QtObject {
        property color bg: Qt.hsla(root.black.hslHue, 0.2, 0.3, 1)
    }
}
