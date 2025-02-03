#!/usr/bin/env bash

pacman -S sddm qt5-graphicaleffects qt5-svg qt5-quickcontrols2

# Get the directory of the current script
SCRIPT_DIR=$(dirname "$(realpath "$0")" )

# echo Symlinking "$SCRIPT_DIR/needkofea/corners" to "/usr/share/sddm/themes/needkofea"
# ln -snf "$SCRIPT_DIR/needkofea/corners" "/usr/share/sddm/themes/needkofea"

sudo rm -R "/usr/share/sddm/themes/needkofea"
sudo cp -R "$SCRIPT_DIR/needkofea/corners" "/usr/share/sddm/themes/needkofea"

echo Successfully Installed theme