#!/bin/bash

# Make sure Docker is available
which docker > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Docker is not available on this system"
  exit 1
fi

# Create directory for working files if it doesn't exist
mkdir -p /tmp

# Clean up any existing resources that might conflict
docker stop my-web > /dev/null 2>&1
docker rm my-web > /dev/null 2>&1
docker rmi my-nginx:v1 > /dev/null 2>&1
rm -f /tmp/Dockerfile /tmp/index.html > /dev/null 2>&1

echo "Setup complete for Question 16"
exit 0 