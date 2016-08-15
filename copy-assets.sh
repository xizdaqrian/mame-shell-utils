#!/bin/bash
#...............................................................................
# assets2.sh
# by Rodney Fisk <xizdaqrian@gmail.com>
# search ROM folder & copy matching assets to appropriate folders
#...............................................................................

check_rom_folder() {
    # Check for ROM folder in DEST
    # TODO: Let any name be the rom folder, not just 'roms'
    readonly ROM_FOLDER=$(find "$DEST" -maxdepth 1 -iname "roms")
    if [ ! -d "$ROM_FOLDER" ]; then
        echo "Rom folder ${tRed}not found${tReset} in $DEST. Check your folders."
        display_help
        exit 1
    else
        echo "Rom folder ${tGreen}found${tReset}: $ROM_FOLDER"
    fi

    # Exit if Rom folder is empty
    i=0
    for file in "$ROM_FOLDER"/*.zip
    do
        # Take everything off, through the last slash, inclusive
        file_base="${file##*/}"
        # Take the suffix off. To remove any suffix, use %%.*
        ROMS[$i]=${file_base%.zip}
        ((i++))
    done
    readonly ROMS

    if [ ${#ROMS[@]} -eq 0 ]; then
        echo "No rom files found in $ROM_FOLDER... exiting"
        exit 1
    else
        echo "There are ${#ROMS[@]} roms in the ROMS folder"
    fi
}

process_assets() {
    # source folder
    s_folder="$SRC"/"$1"
    d_folder="$DEST"/"$1"
    for rom in "${ROMS[@]}"
    do
        # TODO: Decide what to do about other suffixes. Most likely a for loop
        if [ -f "$s_folder"/"$rom".png ]; then
            echo "Asset found for $rom"
            cp -uv -t "$d_folder" "$s_folder"/"$rom".png
        else
            echo "Asset -not- found for $rom"
        fi
    done
}

display_help() {
    SCRIPT_NAME=$( basename "$0" .sh )
    echo "$SCRIPT_NAME"
    echo "USAGE: "$SCRIPT_NAME" SRC DEST"
}

make_target_folders() {
    n_folders=0
    for t_folder in ${ASSETS[@]}; do
        if [ -d "$SRC"/"$t_folder" ]; then
            if [ $( wc -l < <(ls "$SRC"/"$t_folder")) -gt 0 ]; then
                echo -e "Folder $SRC/$t_folder\t${tGreen}found${tReset}, and contains assets"
                mkdir -pv "$DEST"/"$t_folder"
                process_assets "$t_folder"
                ((n_folders++))
            else
                echo "...................................."
                echo ".   Skipping... no assets found    ."
                echo "...................................."
            fi
        else
            echo "$t_folder\t${tRed}not found${tReset}... skipping"
        fi
    done
    if [ $n_folders -eq 0 ]; then
        echo "...................................."
        echo ". Nothing to do... no assets found ."
        echo "...................................."
        exit 1
    else
        echo "...................................."
        echo ". $n_folders asset folders found          ."
        echo "...................................."
    fi
}


# Verify that we have exactly 2 parameters, and that DEST isn't '/'
if [ $# != 2 ] || [ -z $1 ] || [ -z $2 ] || [ "$2" = "/" ]; then
    display_help
    exit 1
fi

# Colors
tReset="$(tput sgr0)"
tRed="$(tput setaf 1)"
tGreen="$(tput setaf 2)"
unset ASSETS
readonly ASSETS=( artwork bosses cabinets cpanel flyers gameover icons manuals \
    marquees snap )
SCRIPT_NAME=$( basename "$0" .sh )
SRC="$1"
DEST="$2"

check_rom_folder
make_target_folders
