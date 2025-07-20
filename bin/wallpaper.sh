#!/usr/bin/env bash

if ! command -v mpvpaper &> /dev/null; then
    echo "mpvpaper is not installed. Please install it first."
    exit 1
fi

CURRENT_WALLPAPER_PATH="$HOME/.cache/current_wallpaper"

kill_mpvpaper() {
    killall mpvpaper
}

# Function to initialize mpvpaper
initialize_mpvpaper() {

    # Initialize mpvpaper
    mpvpaper -p -o "no-audio" "*"
    echo "mpvpaper initialized successfully."
}



restore() {
    kill_mpvpaper
    if [[ ! -f "$CURRENT_WALLPAPER_PATH" ]]; then
        echo "Error: Could not find last wallpaper!"
        exit 1
    fi
    mpvpaper --fork -p -o "no-audio loop-file" "*" $CURRENT_WALLPAPER_PATH --gpu-api=vulkan
    echo "Restored wallpaper from $CURRENT_WALLPAPER_PATH"
}

# Function to set wallpaper using mpvpaper
set_wallpaper() {

    local image_path="$1"

    if [[ ! -f "$image_path" ]]; then
        echo "Error: The specified image does not exist: $image_path"
        exit 1
    fi

    mkdir "$HOME/.cache"
    # Set the wallpaper using mpvpaper
    cp $image_path $CURRENT_WALLPAPER_PATH -f
    echo "Current wallpaper set to $image_path; Saved to $CURRENT_WALLPAPER_PATH"
    restore
}

# Main function to handle commands
main() {
    case "$1" in
        kill)
            kill_mpvpaper
            ;;
        restore)
            restore
            ;;
        set)
            if [ -z "$2" ]; then
                echo "Error: Please provide a path to the image file."
                exit 1
            fi
            set_wallpaper "$2"
            ;;
        *)
            echo "Usage: $0 {restore|kill|set <image_path>}"
            exit 1
            ;;
    esac
}

# Call the main function with the script arguments
main "$@"
