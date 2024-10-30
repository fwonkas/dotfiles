#!/bin/sh

echo "Creating Target CA bundle directory..."
mkdir -p "$HOME"/.config/target-certs

# Download the Target CA bundle
echo "Downloading Target CA bundle..."
if ! curl -s -o "$HOME"/.config/target-certs/tgt-ca-bundle.crt \
    https://browserconfig.target.com/tgt-certs/tgt-ca-bundle.crt
then
    echo "Failed to download Target CA bundle."
    exit 1
else
    echo "Downloaded and installed Target CA bundle."
fi