#!/bin/bash

# Lines to check for in /etc/profile
line1='export LD_LIBRARY_PATH="/usr/local/lib/openssl/openssl/lib:$LD_LIBRARY_PATH"'
line2='export PATH="/usr/local/bin:$PATH"'
target_line='PATH="/usr/local/bin:/usr/bin:/bin"'

# Check if /home/root directory exists
if [ -d "/home/root" ]; then
    # Check if the target line is present in /etc/profile
    if grep -Fxq "$target_line" /etc/profile; then
        # Check if both lines are present in /etc/profile
        if grep -Fxq "$line1" /etc/profile && grep -Fxq "$line2" /etc/profile; then
            echo "Both lines are already present in /etc/profile."
        else
            # If either line is missing, add them before the target_line
            if ! grep -Fxq "$line1" /etc/profile; then
                sed -i "\|$target_line|i $line1" /etc/profile
                echo "Added: $line1"
            fi

            if ! grep -Fxq "$line2" /etc/profile; then
                sed -i "\|$target_line|i $line2" /etc/profile
                echo "Added: $line2"
            fi

            echo "Lines added successfully."
        fi
    else
        echo "Error: Target line not found in /etc/profile."
    fi
else
    echo "Error: The /home/root directory does not exist. Lines were not added to /etc/profile."
fi