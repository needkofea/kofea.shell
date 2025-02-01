#! /usr/bin/env bash

_DIR=$( dirname -- "$0" )

starter_pkgs=(
    "python3"
    "rust"
    "git"
)


install_starter_pkgs(){
    pacman -Sy "${starter_pkgs[@]}"
}



echo "NeedKofea bootstrap.sh"
echo "Installing installer dependencies..."
install_starter_pkgs


# Run install script
python3 $_DIR/install-all.py
