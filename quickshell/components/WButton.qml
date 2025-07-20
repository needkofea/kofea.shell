import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../services"

Rectangle {
    id: ctn

    implicitWidth: 86
    implicitHeight: 42
    radius: 4

    property string text
    property alias font: label.font

    signal clicked(mouse: MouseEvent)

    color: {
        if (mouseArea.containsPress) {
            return Theme.controls.bg_pressed;
        }

        if (mouseArea.containsMouse) {
            return Theme.controls.bg_hover;
        }
        return Theme.controls.bg;
    }

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        cursorShape: Qt.PointingHandCursor

        onPositionChanged: mouse => {
            mouse.accepted = false;
        }

        onClicked: mouse => {
            ctn.clicked(mouse);
        }
    }
    Text{
        id: label
        color: Theme.controls.fg
        anchors.centerIn: parent
        text: ctn.text
    }
}
