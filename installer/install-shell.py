#! /usr/bin/env python3

from utils import  KOFEA_DOTS_DESKTOP, KOFEA_DOTS_SYSTEM, TargetInstaller, USER_HOME, TARGET_DOTS_CONFIG


home = TargetInstaller(KOFEA_DOTS_SYSTEM, USER_HOME)
dots = TargetInstaller(KOFEA_DOTS_DESKTOP, TARGET_DOTS_CONFIG)

def install_self():
    home.install(".zshrc")
    dots.install("starship")
    pass


if __name__ == "__main__":
    install_self()
