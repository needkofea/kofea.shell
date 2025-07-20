import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../../../services"

ClippingRectangle {
    id: root

    radius: 4

    implicitWidth: 86
    implicitHeight: layout.height

    property bool toggled: false
    property string leftIconSource
    signal clickedLeft(mouse: MouseEvent)
    signal clickedRight(mouse: MouseEvent)
    property string rightIconSource
    color: Theme.border

    RowLayout {
        id: layout
        spacing: 1
        ToggleButton {
            implicitWidth: root.width * 3 / 5
            iconSource: root.leftIconSource
            toggled: root.toggled
            onClicked: mouse => {
                root.clickedLeft(mouse);
            }
            radius: 0
        }
        ToggleButton {
            iconSource: Quickshell.iconPath("pan-start-symbolic-rtl")
            implicitWidth: root.width * 2 / 5
            onClicked: mouse => {
                root.clickedRight(mouse);
            }
            radius: 0
        }
    }
}
