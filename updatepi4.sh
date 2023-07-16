#!/bin/bash

# Define the GitHub repository URL
REPO_URL="https://github.com/PowerTuneDigital/YoctoExtraPackages.git"

# Define the paths for Perl and OpenSSL
PERL_INSTALL_PATH="/usr/local/lib/perl5/5.38.0"
OPENSSL_INSTALL_PATH="/usr/local/lib/openssl/openssl"
OPENSSL_BIN_PATH="/usr/local/bin"

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if 'git' command is available
if ! command_exists git; then
    echo "Error: 'git' command not found. Please install git before running this script."
    exit 1
fi

# Clone the GitHub repository to the temporary directory
cd /home/pi/
TMP_DIR="$(mktemp -d)"
git clone "$REPO_URL" "$TMP_DIR"

# Check if the tarball exists
if [ -f "$TMP_DIR/compiled_perl_openssl.tar.gz" ]; then
    echo "Tarball found in the downloaded directory. Continuing..."
    # Navigate to the extracted directory containing the tarball
    cd "$TMP_DIR"

    # Extract the tarball
    tar -xzf compiled_perl_openssl.tar.gz

    # Create necessary directories if they don't exist
    mkdir -p "$PERL_INSTALL_PATH"
    mkdir -p "$OPENSSL_INSTALL_PATH"
    mkdir -p "$OPENSSL_BIN_PATH"

    # Copy the compiled Perl and OpenSSL files to the correct paths
    cp -r perl "$PERL_INSTALL_PATH"
    cp -r openssl "$OPENSSL_INSTALL_PATH"
    cp openssl/bin/openssl "$OPENSSL_BIN_PATH"

    # Register the versions of Perl and OpenSSL
    echo "export PATH=\"$OPENSSL_BIN_PATH:\$PATH\"" > /etc/profile.d/yocto_extra_packages.sh
    echo "export LD_LIBRARY_PATH=\"$OPENSSL_INSTALL_PATH/openssl/openssl/lib:\$LD_LIBRARY_PATH\"" >> /etc/profile.d/yocto_extra_packages.sh

    # Reload the profile to apply the changes for the current session
    source /etc/profile.d/yocto_extra_packages.sh

    # Inform user about successful installation
    echo "Installation completed successfully. Please log out and log back in to apply the changes."
    echo "After logging back in, you can check OpenSSL version with 'openssl version'."
else
    echo "Error: The tarball 'compiled_perl_openssl.tar.gz' not found in the downloaded directory."
    ls -al "$TMP_DIR"
    exit 1
fi

