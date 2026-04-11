#!/bin/bash

shopt -s nullglob

for file in *.ogg; do
    echo "Processing: $file"

    # Get max volume
    max_vol=$(ffmpeg -i "$file" -af volumedetect -f null /dev/null 2>&1 \
        | grep "max_volume" | awk '{print $5}')

    if [ -z "$max_vol" ]; then
        echo "Could not detect volume for $file, skipping."
        continue
    fi

    # Remove minus sign to get gain
    gain=$(echo "$max_vol" | sed 's/-//')

    echo "Max volume: $max_vol → Applying gain: +$gain dB"

    tmp="${file%.ogg}_tmp.ogg"

    # Apply gain to temp file
    ffmpeg -y -i "$file" -af "volume=${gain}dB" -c:a libvorbis "$tmp"

    # Replace original if successful
    if [ $? -eq 0 ]; then
        mv "$tmp" "$file"
        echo "Updated: $file"
    else
        echo "Failed to process $file"
        rm -f "$tmp"
    fi
done