pragma Singleton

import Quickshell

Singleton {
    id: root
    property ShellScreen quickControlActiveScreen: null
    property ShellScreen mouseBlockerActiveScreen: null
    signal mouseBlocked()


    function openQuickControls(screen: ShellScreen) {
        root.mouseBlockerActiveScreen = screen; // IMPORTANT, must enable blocker first so that other panels show up infront of blocker.
        root.quickControlActiveScreen = screen;
    }

    function closeQuickControls() {
        root.quickControlActiveScreen = null;
        root.mouseBlockerActiveScreen = null;
    }
    function toggleQuickControls(screen: ShellScreen) {
        if (root.quickControlActiveScreen == screen) {
            console.log("Close quick controls");
            closeQuickControls();
            return;
        }
        openQuickControls(screen);
    }
}
