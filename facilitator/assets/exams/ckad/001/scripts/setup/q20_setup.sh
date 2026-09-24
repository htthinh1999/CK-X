#!/bin/bash

# Setup for Question 22: Pull and store nginx image in OCI format

# Create the directory for storing OCI images
mkdir -p /root/oci-images

# Remove any existing content to ensure clean state
rm -rf /root/oci-images/*

# Make sure required tools are installed

if ! command -v docker &> /dev/null; then
    echo "Installing docker for image pulling..."
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
fi

echo "Setup complete for Question 22: Environment ready for pulling and storing the nginx image in OCI format"
echo "Task: Pull the nginx:latest image and store it in OCI format in the directory /root/oci-images"
exit 0 