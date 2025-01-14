#!/usr/bin/env bash

_DIR=$(dirname "$(realpath "$0")")

ASSET_DIR="$HOME/kofea.shell/assets/icons"

# Check if pamixer is installed
if ! command -v pamixer &>/dev/null; then
    echo "pamixer is not installed. Please install it first."
    exit 1
fi

TEMP_FILE="/tmp/volume-output-last-notification.tmp"
PREV_ID=$(cat "$TEMP_FILE" 2>/dev/null)
if [[ -n "$PREV_ID" ]]; then
    NOTIFY_ARGS="-r $PREV_ID"
fi

pamixer --default-source -t
if  [[ $(pamixer --default-source --get-mute) == "true" ]]; then
    echo "Toggle Mute: Muted default mic";
    NOTIFY_ID=$(notify-send -a "Toggle Mute" "Muted" -t 2000 -u low $NOTIFY_ARGS -p -i "$ASSET_DIR/IconoirMicrophoneMuteSolid.svg")
else
    echo "Toggle Mute: Unmuted default mic";
    NOTIFY_ID=$(notify-send -a "Toggle Mute" "Unmuted" -t 2000 -u low $NOTIFY_ARGS -p -i "$ASSET_DIR/IconoirMicrophoneSolid.svg")
fi


echo $NOTIFY_ID > $TEMP_FILE
