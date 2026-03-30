#!/bin/bash

if [[ $(playerctl status 2>/dev/null) == "Playing" ]]; then
    status='▷  '
else
    status='  '
fi

song_info=$(playerctl metadata --format "$status {{title}}      {{artist}}")

echo "$song_info"

