#!/bin/bash

# File to be checked
file="/etc/init.d/powertune"

# Search for the specific line containing "nohup ./PowertuneQMLGui -platform eglfs &"
if grep -q "nohup ./PowertuneQMLGui -platform eglfs &" "$file"; then
    echo "Apply nohup fix"
    
    # Replace the line with "./PowertuneQMLGui -platform eglfs &"
    sed -i 's|nohup ./PowertuneQMLGui -platform eglfs &|./PowertuneQMLGui -platform eglfs &|' "$file"
else
    echo "Nohup patch not required"
fi

# Quit the script
exit 0
