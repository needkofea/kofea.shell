// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property color accent: "#1100ff"

    property color bright: Qt.hsla(accent.hslHue, 0.4, 0.85, 1)
    property color black: Qt.hsla(accent.hslHue - 0.25, 0.02, 0.05, 1)


    property color border: Qt.hsla(0, 0, 1, 0.5)

    property color background: root.black

    property var workspace: QtObject {
        property var inactive: QtObject {
            property color bg: Qt.hsla(root.black.hslHue, root.black.hslSaturation, 0.15, 1)
        }

        property var active: QtObject {
            property color bg: root.bright
        }

        property var hover: QtObject {
            property color bg: Qt.hsla(root.black.hslHue, root.black.hslSaturation, 0.25, 1)
        }
    }

    property var taskbar: QtObject {
        property var item: QtObject {
            property var active: QtObject {
                property color bg: root.black
            }
            property var normal: QtObject {
                property color fg: root.black
                property color bg: "transparent"
            }
            property var hover: QtObject {
                property color fg: root.black
                property color bg: Qt.hsla(root.black.hslHue, 0, 1, 0.3)
            }
        }
    }
}
