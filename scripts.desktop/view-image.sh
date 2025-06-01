#! /usr/bin/env bash

if ! command -v "feh" &> /dev/null; then
    echo "feh is not installed. Please install it first with \"pacman -Sy feh\""
    exit 1
fi

feh --auto-zoom "$@"
