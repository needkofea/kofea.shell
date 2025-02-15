#! /usr/bin/env bash

_DIR=$( dirname -- "$0" )

ORIGINAL_USER=$SUDO_USER

set -e

echo -e "--- [ Kofea.Shell \033[35mbootstrap.sh\033[0m ] --- "


if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "\033[0;31m[Fatal Error]\033[0m This script requires \033[1;31mroot\033[0m privileges! Please run with sudo. (sudo ~/kofea.shell/installer/bootstrap.sh)"
    exit
fi

echo -e "\033[35mbootstrap.sh\033[0m will install, setup and start the \033[32;1mKofea.Shell installer\033[0m. This process \033[0;31mmay break your system\033[0m. Please ensure you have backed it up."
echo
read -p "Are you sure you want to continue? (y/N): " choice

if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "installation cancelled."
    exit
fi


starter_pkgs=(
    "python3"
    "python-pip"
    "rust"
    "git"
)


install_starter_pkgs(){
    pacman -Sy "${starter_pkgs[@]}" --needed
    # Install json5 python package
    python3 -m pip install pyjson5 --break-system-packages
}

install_yay(){

    echo -n "Checking for yay (AUR Helper)..."
    if command -v yay &> /dev/null; then
        echo -ne "\rYay is installed! Skipping...                  \n"
        return 0
    else
        echo -ne "\rYay is not installed! Starting yay installation...\n"
    fi


    pacman -S --needed git base-devel
    # Install yay without root privelages
    sudo -u $ORIGINAL_USER rm -f -r yay-bin
    sudo -u $ORIGINAL_USER git clone https://aur.archlinux.org/yay-bin.git
    sudo -u $ORIGINAL_USER cd yay-bin
    sudo -u $ORIGINAL_USER makepkg -si
    sudo -u $ORIGINAL_USER cd ..
    #
}


echo "NeedKofea bootstrap.sh"
echo "Installing installer dependencies..."
install_starter_pkgs
install_yay

echo Starting installer...
# Run install script
python3 $_DIR/installer.py
