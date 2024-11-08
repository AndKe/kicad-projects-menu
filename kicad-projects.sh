#!/bin/bash

# SET YOUR PROJECT DIRECTORY
PROJECT_DIR="$HOME/KiCad"

FOUND_PROJECTS=$(find -L "$PROJECT_DIR" -type f -name "*.kicad_pro")

# Populate OPTIONS and PROJECTS arrays
OPTIONS=()
PROJECTS=()
while IFS= read -r project; do
    OPTIONS+=("$(dirname "$project")")
    PROJECTS+=("$(basename "$project")")
done <<< "$FOUND_PROJECTS"

# Check if any projects were found
if [ ${#OPTIONS[@]} -eq 0 ]; then
    echo "No projects found in $PROJECT_DIR."
    exit 1
fi

# Combine OPTIONS and PROJECTS into a single array of tuples
combined=()
for i in "${!OPTIONS[@]}"; do
    combined+=("${OPTIONS[$i]}|${PROJECTS[$i]}")
done

# Sort it
IFS=$'\n' sorted=($(sort <<<"${combined[*]}"))
unset IFS

# Split the sorted array back into OPTIONS and PROJECTS
OPTIONS=()
PROJECTS=()
for entry in "${sorted[@]}"; do
    OPTIONS+=("${entry%|*}")
    PROJECTS+=("${entry#*|}")
done

# Function to display the menu
print_menu() {
    for i in "${!OPTIONS[@]}"; do
        if [[ $i == $1 ]]; then
            # Highlight the selected option with white text on blue background
            tput setab 4 # Set blue background
            tput setaf 7 # Set white text
            echo "> $(basename "${OPTIONS[$i]}")"
            tput sgr0     # Reset color
        else
            echo "  $(basename "${OPTIONS[$i]}")"
        fi
    done
}

selected=0

# Main loop
tput civis
trap 'tput cnorm' EXIT
while true; do
    clear
    echo "Use UP/DOWN arrow keys to navigate, Enter to select, ESC to exit."
    print_menu $selected

    # Capture keypress
    read -rsn1 key
    case $key in
        $'\x1b') # ESC key
            read -rsn2 -t 0.1 key
            if [[ $key == '[A' ]]; then
                # Arrow up
                ((selected--))
                if [[ $selected -lt 0 ]]; then
                    selected=$((${#OPTIONS[@]} - 1))
                fi
            elif [[ $key == '[B' ]]; then
                # Arrow down
                ((selected++))
                if [[ $selected -ge ${#OPTIONS[@]} ]]; then
                    selected=0
                fi
            else 
                # some other ESCape code
                exit
            fi
            ;;
        "") # Enter key
            echo "Path: ${OPTIONS[$selected]}"
            echo "Project file: ${PROJECTS[$selected]}"
            # Run KiCad with the selected project, in the project directory
            cd "${OPTIONS[$selected]}"
            # use nohup to run in background - needed for use with .desktop file
            nohup kicad "${PROJECTS[$selected]}" > /dev/null 2>&1 & 
            sleep 0.5 # needed for .desktop file to work
            exit
            ;;
        *) # Invalid input
            ;;
    esac
done
