import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import "../../services"

IconImage {

    required property color color
    property bool colorised: true
    property Item child

    ColorOverlay {
        enabled: parent.colorised
        visible: parent.colorised
        anchors.fill: parent
        source: parent
        color: parent.color
    }
}
