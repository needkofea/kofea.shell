import QtQuick
import QtQuick.Layouts
import Quickshell
import QtMultimedia
import "../../services"

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        required property var modelData

        screen: modelData
        anchors {
            left: true
            bottom: true
            right: true
            top: true
        }
        exclusionMode: ExclusionMode.Ignore
        aboveWindows: false
        color: "black"

        Video {
            id: video
            anchors.fill: parent
            autoPlay: true
            loops: MediaPlayer.Infinite
            source: Qt.resolvedUrl(WallpaperService.currentWallpaperFilepath)
            fillMode: VideoOutput.PreserveAspectCrop
            muted: true

            Component.onCompleted: {
                console.log("Reading wallpaper from", WallpaperService.currentWallpaperFilepath);
            }
            onSourceChanged: {
                console.log("Wallpaper source:", source);
                video.play()
            }
            onErrorChanged:{
                console.error("Wallpaper error", video.errorString)
            }
            onPaused: {
                console.log("Wallpaper paused");
            }
            onStopped: {
                console.log("Wallpaper Stopped");
            }
            onPlaying: {
                console.log("Wallpaper playing");
            }
        }
    }
}
