#! /usr/bin/env python3

from utils import  KOFEA_DOTS, USER_HOME, TARGET_DOTS_CONFIG, KofeaDotsInstaller
from modules import desktopModule




home = KofeaDotsInstaller(KOFEA_DOTS, USER_HOME)
dotsConfig = home.target(".config")


def install_terminal():
    terminalConf = home.child("terminal")
    terminalConf.install(".zshrc")


def install_apps_config():
    appsConf = dotsConfig.child(".config")
    appsConf.install("zed")


def install_desktop():
    desktopModule.exec_install_dots()

def install_self():
    install_terminal()
    install_desktop()

    install_apps_config();

if __name__ == "__main__":
    install_self()
