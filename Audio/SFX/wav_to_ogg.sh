
#!/bin/bash

# Check for ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not installed."
    exit 1
fi

for file in *.wav; do
    [ -e "$file" ] || continue

    output="${file%.wav}.ogg"

    echo "Converting: $file -> $output"

    ffmpeg -y -i "$file" \
        -ar 32000 \
        -ac 1 \
        -c:a libvorbis \
        -qscale:a 3 \
        "$output"

    if [ $? -eq 0 ]; then
        echo "Deleting original: $file"
        rm "$file"
    else
        echo "Failed: $file"
    fi
done

echo "Done."