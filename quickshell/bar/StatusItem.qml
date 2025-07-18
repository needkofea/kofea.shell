import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../services"

IconImage {

    required property color color
    property bool colorised: true

    ColorOverlay {
        enabled: parent.colorised
        visible: parent.colorised
        anchors.fill: parent
        source: parent
        color: parent.color
    }
}
