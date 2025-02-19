#! /usr/bin/env python3

from utils import  KOFEA_DOTS, USER_HOME, TARGET_DOTS_CONFIG, KofeaDotsInstaller




home = KofeaDotsInstaller(KOFEA_DOTS, USER_HOME)
dotsConfig = home.target(".config")


def install_gtkTheme():
    home.copy(".themes/catppucin-mocha-rosewater") # Main gtk theme
    home.install(".icons/Bibata-Modern-Ice") # Cursor theme

def install_terminal():
    terminalConf = home.child("terminal")
    terminalConf.install(".zshrc")


def install_apps_config():
    appsConf = dotsConfig.child("apps")
    appsConf.install("zed")


def install_desktop():
    desktop_dots = dotsConfig.child("desktop")
    desktop_dots.install("wal")
    desktop_dots.install("kitty")
    desktop_dots.install("sddm")
    desktop_dots.install("swaylock")
    desktop_dots.install("starship")
    desktop_dots.install("ags")
    desktop_dots.install("hypr")
    desktop_dots.install("dunst")
    desktop_dots.install("rofi")
    desktop_dots.install("waybar")

def install_self():
    install_terminal()
    install_desktop()
    install_gtkTheme();
    install_apps_config();

if __name__ == "__main__":
    install_self()
