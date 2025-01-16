#! /usr/bin/env python3

from utils import install_target


def install_self():
    install_target("ags")
    install_target("hypr")
    install_target("dunst")
    install_target("starship")
    install_target("rofi")
    install_target("waybar")
    pass


if __name__ == "__main__":
    install_self()
