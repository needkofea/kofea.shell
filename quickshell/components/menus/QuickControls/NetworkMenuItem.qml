import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects

import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import "../../../services"
import "../.."

Rectangle {
    id: root
    implicitHeight: layout.height + 14
    implicitWidth: layout.width + 14
    radius: 6

    required property string name
    required property string desc
    required property string label
    signal clicked()
    signal toggleExpanded()

    property bool expanded: false

    border.color: Theme.widget.bg
    color: {
        if (mouseArea.containsMouse) {
            return Theme.hover;
        }
        return "transparent";
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 150
            easing.type: Easing.InOutQuart
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
            root.toggleExpanded();
        }
    }

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        width: 256

        Text {
            text: root.name
            color: Theme.widget.fg
            font.weight: 500
            font.pointSize: 10
        }
        Text {
            text: root.desc
            color: Theme.widget.fg
            font.pointSize: 8
            font.weight: 500
        }
        WButton {
            Layout.alignment: Qt.AlignRight
            enabled: root.expanded
            visible: root.expanded
            implicitHeight: 32
            implicitWidth: 100
            font.weight: 600
            text: label

            onClicked: () => root.clicked()
        }
    }
}
