#! /usr/bin/env python3


ascii_art=r"""
╔─────────────────────────────────────────────────────────────────────────────────────────────────╗
│    __    __            ______                            ______   __                  __  __    │
│   |  \  /  \          /      \                          /      \ |  \                |  \|  \   │
│   | $$ /  $$ ______  |  $$$$$$\ ______    ______       |  $$$$$$\| $$____    ______  | $$| $$   │
│   | $$/  $$ /      \ | $$_  \$$/      \  |      \      | $$___\$$| $$    \  /      \ | $$| $$   │
│   | $$  $$ |  $$$$$$\| $$ \   |  $$$$$$\  \$$$$$$\      \$$    \ | $$$$$$$\|  $$$$$$\| $$| $$   │
│   | $$$$$\ | $$  | $$| $$$$   | $$    $$ /      $$      _\$$$$$$\| $$  | $$| $$    $$| $$| $$   │
│   | $$ \$$\| $$__/ $$| $$     | $$$$$$$$|  $$$$$$$  __ |  \__| $$| $$  | $$| $$$$$$$$| $$| $$   │
│   | $$  \$$\\$$    $$| $$      \$$     \ \$$    $$ |  \ \$$    $$| $$  | $$ \$$     \| $$| $$   │
│    \$$   \$$ \$$$$$$  \$$       \$$$$$$$  \$$$$$$$  \$$  \$$$$$$  \$$   \$$  \$$$$$$$ \$$ \$$   │
│                                                                                                 │
│         -------------------------------- { Installer } --------------------------------         │
╚─────────────────────────────────────────────────────────────────────────────────────────────────╝
"""

if __name__ == "__main__":
    print(ascii_art)
    print("Warning:\nThis script will not help you install Nvidia drivers! Please ensure it is installed and setup for wayland & Hyprland before you start!")
    print("Beginning full installation of kofea.shell! This is may break your system! Please ensure it is backed up!")
    ans = input("Continue? (yes/N)")
    if ans != "yes":
        print("Cancelled!")
        exit(-1)

    print("Installing Chaotic AUR...")
    __import__("setup-chaoticaur").install_self()
