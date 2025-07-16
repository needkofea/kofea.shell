import Quickshell
import Quickshell.Io
import QtQuick
import "bar"

Scope {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar {
                property var modelData

                screen: modelData
                anchors {
                    bottom: true
                    left: true
                    right: true
                }
            }
        }
    }
}
