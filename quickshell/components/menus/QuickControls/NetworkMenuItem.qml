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
    implicitHeight: layout.height
    implicitWidth: layout.width
    radius: 6

    required property string name
    required property string desc
    required property string label
    property string iconSource
    property bool colorised
    signal clicked
    signal toggleExpanded

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
        id: heightAnim
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

    IconImage {
        visible: !!root.iconSource
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.topMargin: 8
        implicitSize: 32
        source: root.iconSource

        ColorOverlay {
            enabled: root.colorised
            visible: root.colorised
            anchors.fill: parent
            source: parent
            color: "white"
        }
    }

    WrapperItem {
        id: layout
        margin: 8
        leftMargin: !!root.iconSource ? 48 : margin
        implicitWidth: 256

        ColumnLayout {

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
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignRight
                enabled: root.expanded
                visible: root.expanded
                implicitHeight: 32
                implicitWidth: 100
                font.weight: 600
                text: label

                onClicked: () => {
                    if (!heightAnim.animation.complete)
                        return;
                    root.clicked();
                }
            }
        }
    }
}
