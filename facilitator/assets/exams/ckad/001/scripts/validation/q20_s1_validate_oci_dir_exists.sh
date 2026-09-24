#!/bin/bash

# Validate that an OCI directory exists in the specified path

OCI_DIR="/root/oci-images"

if [ -d "$OCI_DIR" ]; then
    # Check if the directory has some content (not empty)
    if [ "$(ls -A $OCI_DIR)" ]; then
        echo "SUCCESS: OCI directory exists at $OCI_DIR and contains files."
        exit 0
    else
        echo "ERROR: OCI directory exists at $OCI_DIR but is empty. Did you store the image?"
        exit 1
    fi
else
    echo "ERROR: OCI directory does not exist at $OCI_DIR."
    exit 1
fi 