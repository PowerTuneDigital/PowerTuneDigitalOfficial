#!/bin/bash

# File to be checked
file="/etc/init.d/powertune"

# Search for the specific line containing "nohup ./PowertuneQMLGui -platform eglfs &"
if grep -q "^nohup ./PowertuneQMLGui -platform eglfs &" "$file"; then
    echo "Apply nohup fix"

    # Replace the entire line with "./PowertuneQMLGui -platform eglfs &"
    # This uses the whole-line match to ensure the entire line is replaced correctly
    sed -i '/^nohup \.\/PowertuneQMLGui -platform eglfs &$/c\./PowertuneQMLGui -platform eglfs &' "$file"
else
    echo "Nohup patch not required"
fi

# Quit the script
exit 0
