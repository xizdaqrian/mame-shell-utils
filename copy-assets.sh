#!/bin/bash
#...............................................................................
# assets2.sh
# by Rodney Fisk <xizdaqrian@gmail.com>
# search ROM folder & copy matching assets to appropriate folders
# Version: 0.6b
# Last modified: Tue, 16 Aug 2016 18:00:47 -0500
#...............................................................................

check_rom_folder() {
    # Check for ROM folder in DEST
    # TODO - Let any name be the rom folder, not just 'roms'
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

clear_logfile() {
    rm -f "$LOGFILE"
}

process_assets() {
    # asset folder
    readonly a_folder="$1"
    # source folder
    readonly s_folder="$SRC"/"$1"
    # destination folder
    readonly d_folder="$DEST"/"$1"
    # Number of assets copied (from this folder)
    n_assets=0
    for rom in "${ROMS[@]}"
    do
        # Everything is png, except for manuals.
        # if it's the manuals folder, and an appropriate pdf is in there,
        # copy it.
        # Else, copy the appropriate png.
        if [ "$a_folder" = "[Mm]anuals" ] && [ -f "$folder"/"$rom".pdf ]; then
            cp -uv -t "$d_folder" "$s_folder"/"$rom".pdf | tee -a "$LOGFILE"
            ((n_assets++))
        elif [ -f "$s_folder"/"$rom".png ]; then
            cp -uv -t "$d_folder" "$s_folder"/"$rom".png | tee -a "$LOGFILE"
            ((n_assets++))
        else
            echo "Asset -not- found for $rom" | tee -a "$LOGFILE"
        fi
    done

    echo "Assets found and copied in $a_folder: $n_assets" | tee -a "$LOGFILE"
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
                echo "Folder $SRC/$t_folder found, and contains assets" | tee -a "$LOGFILE"
                mkdir -pv "$DEST"/"$t_folder"
                process_assets "$t_folder"
                ((n_folders++))
            else
                #echo "...................................."
                echo "Folder $SRC/$t_folder empty: Skipping..." | tee -a "$LOGFILE"
                #echo "...................................."
            fi
        else
            echo "$t_folder not found: SKipping..." | tee -a "$LOGFILE"
        fi
    done
    if [ $n_folders -eq 0 ]; then
        #echo "...................................."
        echo " Nothing to do: no assets found..."  | tee -a "$LOGFILE"
        #echo "...................................."
        exit 1
    else
        #echo "...................................."
        echo "ASset folders found: $n_folders" | tee -a "$LOGFILE"
        #echo "...................................."
    fi
}


# Verify that we have exactly 2 parameters, and that DEST isn't '/'
if [ $# != 2 ] || [ -z $1 ] || [ -z $2 ] || [ "$2" = "/" ]; then
    display_help
    exit 1
fi

# Colors
readonly tReset="$(tput sgr0)"
readonly tRed="$(tput setaf 1)"
readonly tGreen="$(tput setaf 2)"

unset ASSETS
readonly ASSETS=( artwork bosses cabinets cpanel flyers gameover icons manuals \
    marquees snap )
SCRIPT_NAME=$( basename "$0" .sh )
readonly SRC="$1"
readonly DEST="$2"
readonly LOGFILE="~/copy-assets.log"
# TODO - Setup getopts to get better input checking

clear_logfile
check_rom_folder            # Calls process_assets
make_target_folders
