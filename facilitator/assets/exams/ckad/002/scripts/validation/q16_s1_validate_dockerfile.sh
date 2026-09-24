#!/bin/bash

# Check if the Dockerfile exists
if [[ ! -f "/tmp/Dockerfile" ]]; then
  echo "❌ File '/tmp/Dockerfile' not found"
  exit 1
fi

# Check if the Dockerfile contains necessary elements
if ! grep -q "FROM.*nginx:alpine" /tmp/Dockerfile; then
  echo "❌ Dockerfile should use 'nginx:alpine' as base image"
  exit 1
fi

if ! grep -q "COPY.*index.html" /tmp/Dockerfile; then
  echo "❌ Dockerfile should copy 'index.html' file"
  exit 1
fi

if ! grep -q "EXPOSE.*80" /tmp/Dockerfile; then
  echo "❌ Dockerfile should expose port 80"
  exit 1
fi

echo "✅ Dockerfile exists with correct content"
exit 0 