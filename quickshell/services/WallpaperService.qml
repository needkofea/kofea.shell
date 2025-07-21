pragma Singleton
import Quickshell

Singleton{
    readonly property string currentWallpaperFilepath: Quickshell.env("HOME") + "/.cache/current_wallpaper"

}