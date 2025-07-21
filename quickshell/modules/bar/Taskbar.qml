import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import "../../services"

Item {
    id: root
    width: childrenRect.width

    required property HyprlandMonitor monitor

    RowLayout {
        height: parent.height

        Repeater {
            id: list

            model: TaskbarServices.getWorkspaces(root.monitor)
            delegate: Item {
                id: wsItem
                required property int modelData
                property int wsId: modelData

                property int dotSize: 6
                property int dotSizeHover: 10

                property int activeHeight: 32
                property int activeWidth: activeContents.width

                property HyprlandWorkspace wsData: Hyprland.workspaces.values.find(x => x.id == wsId)

                property int haveClients: wsData?.toplevels?.values?.length ?? 0 > 0
                property int active: wsData?.active ?? false

                implicitWidth: Math.max(activeWidth, 24)
                implicitHeight: parent.height

                // Text {
                //     color: "yellow"
                //     text: "Index" + parent.index
                // }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        Hyprland.dispatch("workspace " + wsItem.wsId);
                    }
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                }

                Rectangle {
                    anchors.centerIn: parent

                    property int enlargedDot: mouseArea.containsMouse && !haveClients
                    property int dotSize: enlargedDot ? wsItem.dotSizeHover : wsItem.dotSize

                    implicitHeight: wsItem.haveClients ? wsItem.activeHeight : dotSize
                    implicitWidth: {
                        if (wsItem.haveClients) {
                            return wsItem.activeWidth;
                        }

                        return dotSize;
                    }
                    border.color: {
                        if (wsItem.haveClients && mouseArea.containsMouse && !wsItem.active) {
                            return Theme.taskbar.ws_group.hover.border;
                        }
                        if (wsItem.haveClients && wsItem.active) {
                            return Theme.taskbar.ws_group.active.bg;
                        }
                        return Theme.taskbar.ws_group.inactive.border;
                    }
                    color: {
                        if (wsItem.haveClients) {
                            return Theme.taskbar.ws_group.inactive.bg;
                        }
                        if (wsItem.active) {
                            return Theme.taskbar.ws_group.active.no_items;
                        }

                        return Theme.taskbar.ws_group.inactive.no_items;
                    }
                    radius: parent.height / 4

                    Behavior on color {
                        ColorAnimation {}
                    }
                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutSine
                        }
                    }

                    TaskbarItems {
                        id: activeContents
                        ws: wsItem.wsData
                        anchors.centerIn: parent
                        implicitHeight: wsItem.activeHeight
                        opacity: wsItem.haveClients ? 1 : 0
                        visible: wsItem.wsData && wsItem.haveClients
                        expanded: (wsItem.active && wsItem.haveClients) || TaskbarServices.alwaysExpandWsGroup
                        padding: 4

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }
    }
}
