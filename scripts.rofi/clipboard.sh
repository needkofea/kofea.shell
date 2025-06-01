#!/usr/bin/env bash

dir="$HOME/.config/rofi/menus"
theme='clipboard'

## Run
selected=$(cliphist list | rofi -dmenu -m -2 -show -theme "$dir/$theme")

if [ -z "$selected" ]; then
    exit 1
fi

printf "$selected" | cliphist decode | wl-copy
copied=$( wl-paste )

wtype -- $copied
