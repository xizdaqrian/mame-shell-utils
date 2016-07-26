#!/usr/bin/env bash
# copy-assets.sh - Search for roms, and copy associated assets to designated folders
# by Rodney Fisk <xizdaqrian@gmail.com>

SRC_PATH="$1"
DST_PATH="$2"


print_help() {
}

check_for_rom_folder() {
    if [ -d "./[Rr]oms" ]; then
        echo "Roms folder found"
    else
        echo "No rom folder found..."
        print_help
        exit 1
    fi
}

check_for_folder() {
    echo -n "Checking for folder $1..."

    if [ -d "$1" ]; then
        echo "$1 found"
        return 0
    else
        echo "$1 not found"
        return 1
    fi
}

copy_files() {
    echo "Checking for rom and asset folders..."

    for ASSET_FOLDER in artwork bosses cabinets cpanel flyers gameover icons manuals marquees \
        snap cabs ; do
        check_for_folder "$SRC_PATH"/"$ASSET_FOLDER"
    done
}


#......................: TODOs :..........................................#
# TODO: setup options
# TODO: do print_help()
# TODO: put folder list into an array, and parse it from options given
# TODO: operate from blacklist or whitelist, regarding which folders to parse
# TODO: use a set of arrays, or temp files, instead of churning the disk
# TODO: create subfolders in DST_PATH, if that's needed
#.........................................................................#

#.......................: DONE :..........................................#
#.........................................................................#
