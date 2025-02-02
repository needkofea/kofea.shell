#! /usr/bin/env bash

_DIR=$( dirname -- "$0" )

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "\033[0;31m[Fatal Error]\033[0m This script requires \033[1;31mroot\033[0m privileges! Please run with sudo."
    exit
fi


starter_pkgs=(
    "python3"
    "python-pip"
    "rust"
    "git"
)


install_starter_pkgs(){
    pacman -Sy "${starter_pkgs[@]}"
    # Install json5 python package
    python3 -m pip install pyjson5 --break-system-packages
}



echo "NeedKofea bootstrap.sh"
echo "Installing installer dependencies..."
install_starter_pkgs


# Run install script
python3 $_DIR/install.py
