#! /usr/bin/env bash

set -e

echo "This script will install the zsh and use it as your default shell."
echo "Note that it will not setup the dot configs for zsh."

printf 'Continue? (y/n)'
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo Yes
else
    exit
fi

if [ $(id -u) -ne 0 ]; then
    echo "Brrr..."
else
    exit
    echo "Please do not run this script as root!"
fi



# Shell dependencies
sudo pacman -S cmake eza --needed

cargo install starship zoxide
sudo pacman -S --needed -- zsh

chsh -s /usr/bin/zsh
