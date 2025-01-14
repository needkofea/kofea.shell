#!/usr/bin/env bash

ASSET_DIR="$HOME/kofea-shell/assets/icons"

# Check if pamixer is installed
if ! command -v pamixer &>/dev/null; then
    echo "pamixer is not installed. Please install it first."
    exit 1
fi

_DIR=$(dirname "$(realpath "$0")")

TEMP_FILE="/tmp/volume-output-last-notification.tmp"
PREV_ID=$(cat "$TEMP_FILE" 2>/dev/null)
if [[ -n "$PREV_ID" ]]; then
    NOTIFY_ARGS="-r $PREV_ID"
fi

ACTION=$1
VOLUME=$(pamixer --get-volume)
DEVICE_NAME=$(pamixer --get-default-sink | awk -F "\"" '{print $4}')



case "$ACTION" in
    t)
        # Toggle mute (mute/unmute)
        pamixer --toggle-mute

        ;;
    i)
        # Increase volume by n%
        pamixer --increase 3
        ;;
    d)
        # Decrease volume by n%
        pamixer --decrease 3
        ;;
    *)
        echo "Usage: $0 {toggle|increase|decrease}"
        exit 1
        ;;
esac

VOLUME_ICON="$ASSET_DIR/MaterialSymbolsVolumeUpRounded.svg"


if [[ ${VOLUME} -lt 50 ]]; then
    VOLUME_ICON="$ASSET_DIR/MaterialSymbolsVolumeDownRounded.svg"
fi

if [[ $(pamixer --get-mute) == "true" ]]; then
    VOLUME_ICON="$ASSET_DIR/MaterialSymbolsNoSoundRounded.svg"
fi



MESSAGE="Volume ...$(pamixer --get-volume-human)"


NOTIFY_ID=$(notify-send "$MESSAGE" "$DEVICE_NAME" -e -a "Volume Control" -p $NOTIFY_ARGS -i "$VOLUME_ICON")

echo $NOTIFY_ID > $TEMP_FILE
