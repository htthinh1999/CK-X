#!/bin/bash

# Validate that the nginx image is properly stored in OCI format

OCI_DIR="/root/oci-images"

if [ ! -d "$OCI_DIR" ]; then
    echo "ERROR: OCI directory does not exist at $OCI_DIR."
    exit 1
fi

# Check if the image is an OCI layout
if [ ! -f "$OCI_DIR/index.json" ] || [ ! -d "$OCI_DIR/blobs" ]; then
    echo "ERROR: The directory at $OCI_DIR does not appear to contain a valid OCI image layout."
    echo "       A valid OCI layout should contain an index.json file and a blobs directory."
    exit 1
fi

# Check if the image is the nginx image by examining the index.json or manifest files
NGINX_FOUND=false

# First check for "nginx" in index.json
if grep -q "nginx" "$OCI_DIR/index.json" 2>/dev/null; then
    NGINX_FOUND=true
else
    # Try to find nginx in manifests
    for manifest in $(find "$OCI_DIR/blobs" -type f -name "*.json" 2>/dev/null); do
        if grep -q "nginx" "$manifest" 2>/dev/null; then
            NGINX_FOUND=true
            break
        fi
    done
fi

if [ "$NGINX_FOUND" = true ]; then
    echo "SUCCESS: The nginx image appears to be properly stored in OCI format at $OCI_DIR."
    exit 0
else
    echo "ERROR: Could not find evidence that the nginx image is stored in the OCI directory."
    exit 1
fi 