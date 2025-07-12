import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import "root:"

PanelWindow {
    anchors {
        bottom: true
        left: true
        right: true
    }

    color: Theme.background

    implicitHeight: 32

    WrapperItem {
        anchors.fill: parent
        leftMargin: 8
        rightMargin: 8

        Item {
            Workspaces {
                implicitHeight: parent.height
                // Layout.alignment: Qt.AlignLeft
            }
            Workspaces {
                anchors.right: parent.right
                implicitHeight: parent.height
                
            }
        }
    }
}
