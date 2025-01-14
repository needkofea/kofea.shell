#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Function to symlink folders with backup renaming if necessary
install_symlinks() {
    # Arguments:
    # $1 - Array of source folders
    # $2 - Destination directory

    local source_folders=("${!1}")
    local destination="$2"

    # Ensure the destination directory exists
    mkdir -p "$destination"

    for source_raw in "${source_folders[@]}"; do
        source_path=$(realpath "$SCRIPT_DIR/$source_raw")
        # Extract the base name (folder or file) from the source path
        local base_name=$(basename "$source_path")

        # Define the destination path
        local dest_path="$destination/$base_name"
        # Check if the path (file or directory) already exists at the destination
        if [ -e "$dest_path" ]; then

            if [ -L "$dest_path" ]; then
                echo "Removing existing symlink  $dest_path..."
                rm "$dest_path"
            else
                echo "Conflicting path detected! Renaming existing $dest_path to $dest_path.bak ..."
                # If it's a directory or file, rename it with a .bak suffix
                mv "$dest_path" "$dest_path.bak"
            fi
        fi

        # Create the symlink at the destination
        ln -s "$source_path" "$dest_path"
        echo "Created symlink from $source_path to $dest_path"
    done

    echo "Symlink creation process completed."
}


# Relative to path of script!
source_folders=(
    "ags"
    "hypr"
)

destination=".test-config"

install_symlinks source_folders[@] "$destination"
