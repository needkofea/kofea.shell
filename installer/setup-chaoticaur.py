#! /usr/bin/env python3


import subprocess


def install_keys():
    subprocess.run(["pacman-key", "--recv-key", "3056513887B78AEB", "--keyserver", "keyserver.ubuntu.com"])
    subprocess.run(["pacman-key","--lsign-key", "3056513887B78AEB"])

def install_pkgs():
    subprocess.run(["pacman","-U", "--needed","https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"])
    subprocess.run(["pacman","-U", "--needed","https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"])

def edit_pacmanconf():

    with open("/etc/pacman.conf","r") as f:
        contents = f.read()

    if "[chaotic-aur]" in contents:
        return

    with open("/etc/pacman.conf","a") as f:
        f.write("[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist")


def install_self():
    print("Installing Chaotic AUR...")
    install_keys()
    install_pkgs()
    edit_pacmanconf()


if __name__ == "__main__":
    install_self()
