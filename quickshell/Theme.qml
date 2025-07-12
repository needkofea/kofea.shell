// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property color accent: "#92ffd2"

    property color bright: Qt.hsla(accent.hslHue, 0.4, 0.85, 1)
    property color black: Qt.hsla(accent.hslHue - 0.25, 0.02, 0.1, 1)

    property color background: root.black

    property color panel: Qt.hsla(root.background.hslHue, root.background.hslSaturation, .7, .3)
    property color text: "#90a1b9"

    property var controls: QtObject {
        property var active: QtObject {
            property color fg: root.black
            property color bg: root.bright
        }

        property var hover: QtObject {
            property color fg: root.text
            property color bg: Qt.hsla(root.panel.hslHue, 0.1, 0.9, 0.4)
        }
    }
}
