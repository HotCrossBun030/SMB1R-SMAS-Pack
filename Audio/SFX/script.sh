#!/bin/bash

for file in *.ogg; do
    [ -e "$file" ] || continue

    base="${file%.ogg}"
    json_file="${base}.json"

    echo "Creating: $json_file"

    cat > "$json_file" <<EOF
{"variations": {"source": "$file"}}
EOF

done

echo "Done."