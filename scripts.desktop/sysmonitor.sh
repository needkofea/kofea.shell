#!/usr/bin/env bash


sysMon="btop"
term=$(cat $HOME/.config/hypr/keybindings.conf | grep ^'$term' | cut -d '=' -f2)

pkill -x "${sysMon}" || ${term} -e "${sysMon}" &
