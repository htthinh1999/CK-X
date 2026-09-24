#!/bin/bash

# Check if the container exists
docker container inspect my-web > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "❌ Container 'my-web' not found"
  exit 1
fi

# Check if the container is running
CONTAINER_STATE=$(docker container inspect my-web --format '{{.State.Status}}')
if [[ "$CONTAINER_STATE" != "running" ]]; then
  echo "❌ Container 'my-web' is not running (current state: $CONTAINER_STATE)"
  exit 1
fi

# Check if the container is using the correct image
CONTAINER_IMAGE=$(docker container inspect my-web --format '{{.Config.Image}}')
if [[ "$CONTAINER_IMAGE" != "my-nginx:v1" ]]; then
  echo "❌ Container should use 'my-nginx:v1' image (current image: $CONTAINER_IMAGE)"
  exit 1
fi

# Check if port 80 is published to 8080
PORT_MAPPING=$(docker container inspect my-web --format '{{json .HostConfig.PortBindings}}' | grep -o "8080")
if [[ -z "$PORT_MAPPING" ]]; then
  echo "❌ Container should publish port 80 to port 8080 on the host"
  exit 1
fi

echo "✅ Container 'my-web' is running properly"
exit 0 