import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

MouseArea {
    id: root
    required property string text

    hoverEnabled: true
    propagateComposedEvents: true
    onPositionChanged: mouse => {
        // propagate mouse event to parent
        mouse.accepted = false;
    }
    onClicked: mouse => {
        mouse.accepted = false;
    }

    property bool tooltipActive: false

    onEntered: () => {
        timer.restart();
        timer.running = true;
    }

    onExited: () => {
        timer.running = false;
        root.tooltipActive = false;
    }

    PopupWindow {
        anchor.item: root

        anchor.rect.y: -this.height - 4
        anchor.rect.x: (root.width / 2) - (label.width / 2)

        implicitWidth: (label.width ?? 1) + 10
        implicitHeight: (label.height ?? 1) + 4
        visible: root.tooltipActive
        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
        }
    }
    Timer {
        id: timer
        interval: 500
        onTriggered: () => {
            root.tooltipActive = true;
        }
    }
}
