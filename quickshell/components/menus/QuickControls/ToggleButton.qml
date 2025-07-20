import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../../../services"

Rectangle {
    id: ctn

    implicitWidth: 86
    implicitHeight: 42
    radius: 4

    property bool toggled: false
    property string iconSource

    signal clicked(mouse: MouseEvent)

    color: {
        if (mouseArea.containsPress) {
            return Theme.widget.bg_pressed;
        }
        if (toggled) {
            return Theme.widget.bg_active;
        }
        if (mouseArea.containsMouse) {
            return Theme.widget.bg_hover;
        }
        return Theme.widget.bg;
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onPositionChanged: mouse => {
            mouse.accepted = false;
        }

        onClicked: mouse => {
            mouse.accepted = false;
            ctn.clicked(mouse);
        }
    }

    IconImage {
        implicitSize: 16
        source: ctn.iconSource
        anchors.centerIn: parent
        Layout.alignment: Qt.AlignCenter
        ColorOverlay {
            enabled: true
            visible: true
            anchors.fill: parent
            source: parent
            color: "white"
        }
    }
}
