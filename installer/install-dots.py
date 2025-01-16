#! /usr/bin/env python3

from utils import  TargetInstaller, KOFEA_DOTS, DOTS_CONFIG


dots = TargetInstaller(KOFEA_DOTS, DOTS_CONFIG)

def install_self():
    dots.install("ags")
    dots.install("hypr")
    dots.install("dunst")
    dots.install("starship")
    dots.install("rofi")
    dots.install("waybar")
    pass


if __name__ == "__main__":
    install_self()
