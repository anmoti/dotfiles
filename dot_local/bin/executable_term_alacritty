#!/bin/bash

TITLE="Alacritty"
CLASS="Alacritty"
FLOATING=false
COMMAND="$SHELL"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--title)
            TITLE="$2"
            shift
            ;;
        -c|--class)
            CLASS="$2"
            shift
            ;;
        -f|--float)
            FLOATING=true
            ;;
        -e|--exec)
            COMMAND="$2"
            shift
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
    shift
done

if [ "$FLOATING" = true ]; then
    if [ "$CLASS" = "Alacritty" ]; then
        CLASS="AlacrittyFloat"
    fi
fi

alacritty --title "$TITLE" --class "$CLASS" --command "$COMMAND"
