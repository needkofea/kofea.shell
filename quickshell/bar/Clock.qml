import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../services"

Item {
    id: root
    implicitWidth: container.width

    required property HyprlandMonitor monitor
    property bool use24hours: false

    Rectangle {
        id: container
        color: mouse.containsMouse ? Theme.clock.bg_hover : Theme.clock.bg
        anchors.centerIn: parent

        property int margin: 12
        implicitWidth: layout.width + 18
        height: parent.height - margin

        radius: parent.height / 8

        WrapperItem {
            anchors.centerIn: parent
            topMargin: 1.5

            ColumnLayout {
                id: layout
                spacing: -4
                RowLayout {
                    spacing: 2
                    property var font_family: FontServices.clockFont
                    property var font_size: 8
                    property var font_weight: 700
                    Layout.alignment: Qt.AlignRight

                    Text {
                        font.weight: parent.font_weight
                        font.family: parent.font_family
                        font.pointSize: parent.font_size
                        color: Theme.clock.fg
                        property int hours: clock.hours > 12 && (!root.use24hours) ? clock.hours - 12 : clock.hours
                        text: `${hours}`.padStart(2, 0)
                    }
                    Text {
                        font.weight: parent.font_weight
                        font.family: parent.font_family
                        font.pointSize: parent.font_size
                        text: `${clock.minutes}`.padStart(2, 0)
                        color: Theme.clock.fg
                    }

                    Text {
                        font.weight: parent.font_weight
                        font.family: parent.font_family
                        font.pointSize: parent.font_size
                        color: Theme.clock.fg
                        text: clock.hours >= 12 ? "PM" : "AM"
                    }
                }
                RowLayout {

                    property var font_family: FontServices.clockFont
                    property var font_size: 7.5
                    property var font_weight: 500

                    Text {
                        font.weight: parent.font_weight
                        font.family: parent.font_family
                        font.pointSize: parent.font_size
                        color: Theme.clock.date_fg
                        text: clock.date.toDateString()
                    }
                }
            }
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }

        Behavior on color {
            ColorAnimation {}
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
