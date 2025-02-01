#! /usr/bin/env python3

from utils import  KOFEA_SYSTEM, TargetInstaller, USER_HOME


home = TargetInstaller(KOFEA_SYSTEM, USER_HOME)

def install_self():
    home.install(".zshrc")

    pass


if __name__ == "__main__":
    install_self()
