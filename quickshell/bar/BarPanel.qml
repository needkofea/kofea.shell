import Quickshell

Variants {
    model: Quickshell.screens

    delegate: Bar {
        property var modelData

        screen: modelData
        anchors {
            bottom: true
            left: true
            right: true
        }
    }
}
