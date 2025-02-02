#! /usr/bin/env python3

from utils import  KOFEA_DOTS_DESKTOP, TargetInstaller, KOFEA_DOTS, TARGET_DOTS_CONFIG


dots = TargetInstaller(KOFEA_DOTS_DESKTOP, TARGET_DOTS_CONFIG)

def install_self():
    dots.install("ags")
    dots.install("hypr")
    dots.install("dunst")
    dots.install("rofi")
    dots.install("waybar")
    pass


if __name__ == "__main__":
    install_self()
