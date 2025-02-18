#! /usr/bin/env bash


# This scripts setups the xdg-menu app list used by dolphin and other stuff
# It will also symlink the directory to the .config file.


set -e

# install archlinux-xdg-menu to get arch-applications.menu file
sudo pacman -S archlinux-xdg-menu


mkdir -p $HOME/.config/menus/
# Copy template file to .config
sudo cp -f /etc/xdg/menus/arch-applications.menu $HOME/.config/menus/applications.menu

echo "Creating symlink..."
# Symlink
sudo ln -fs $HOME/.config/menus/applications.menu /etc/xdg/menus/applications.menu

echo "Runnning kbuildsycoca6..."
# Run kbuild
sudo kbuildsycoca6
echo "Updating apps list..."
# Update applist
$kofea/update-appslist.sh
