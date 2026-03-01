#!/bin/bash

# Check for ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not installed."
    exit 1
fi

for file in *.ogg; do
    [ -e "$file" ] || continue

    temp="${file%.ogg}_tmp.ogg"

    echo "Recompressing: $file"

    ffmpeg -y -i "$file" \
        -ar 32000 \
        -c:a libvorbis \
        -qscale:a 4 \
        "$temp"

    if [ $? -eq 0 ]; then
        echo "Replacing original: $file"
        mv "$temp" "$file"
    else
        echo "Failed: $file"
        rm -f "$temp"
    fi
done

echo "Done."