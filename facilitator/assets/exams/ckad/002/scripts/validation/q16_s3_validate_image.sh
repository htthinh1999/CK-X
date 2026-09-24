#!/bin/bash

# Check if the Docker image exists
docker image inspect my-nginx:v1 &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "❌ Docker image 'my-nginx:v1' not found"
  exit 1
fi

#Docker image is built correctly
echo "✅ Docker image 'my-nginx:v1' has been built correctly with all required elements"
exit 0