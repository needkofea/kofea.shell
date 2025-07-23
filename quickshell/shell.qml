//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "./modules/bar"
import "./components/menus/QuickControls"
import "./modules/wallpaper"
import "./services"

ShellRoot {

    QuickControlPanel {}
    BarPanel {}
    WallpaperPanel {}

    PanelWindow {
        screen: PanelServices.mouseBlockerActiveScreen
        visible: !!PanelServices.mouseBlockerActiveScreen
        implicitWidth: screen?.width
        implicitHeight: screen?.height
        exclusiveZone: 0

        color: "transparent"
        onScreenChanged: {
            console.log("Mouse blocker active: ", visible);
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                PanelServices.mouseBlocked();
            }
        }
    }
}
