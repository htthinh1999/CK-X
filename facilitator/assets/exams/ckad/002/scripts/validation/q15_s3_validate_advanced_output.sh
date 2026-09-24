#!/bin/bash

# Check if the output file exists
if [[ ! -f "/tmp/all-container-images.txt" ]]; then
  echo "❌ File '/tmp/all-container-images.txt' not found"
  exit 1
fi

# Check if the file has content
if [[ ! -s "/tmp/all-container-images.txt" ]]; then
  echo "❌ File '/tmp/all-container-images.txt' is empty"
  exit 1
fi

# Check if the file contains multi-container pod information
# Our setup included a pod named multi-container-pod with nginx and busybox containers
MULTI_CONTAINER_LINE=$(grep "multi-container-pod" /tmp/all-container-images.txt)
if [[ -z "$MULTI_CONTAINER_LINE" ]]; then
  echo "❌ File should contain information about multi-container-pod"
  exit 1
fi

# Check if both container images are listed for the multi-container pod
# This could be done in several ways depending on the output format chosen by the user
if echo "$MULTI_CONTAINER_LINE" | grep -q "nginx:alpine" && echo "$MULTI_CONTAINER_LINE" | grep -q "busybox:1.34"; then
  # Both images are found on the same line
  echo "✅ File correctly shows both container images for multi-container-pod"
elif [[ $(grep "multi-container-pod.*nginx:alpine" /tmp/all-container-images.txt | wc -l) -gt 0 && $(grep "multi-container-pod.*busybox:1.34" /tmp/all-container-images.txt | wc -l) -gt 0 ]]; then
  # Images might be on separate lines
  echo "✅ File contains both container images for multi-container-pod"
else
  echo "❌ File should list both nginx:alpine and busybox:1.34 images for multi-container-pod"
  exit 1
fi

# Check if the file format includes the pod name and namespace
# This is a simplistic check - there are multiple valid formats
if grep -q "POD.*NAMESPACE.*IMAGES" /tmp/all-container-images.txt || grep -E -q ".*,.*,.*" /tmp/all-container-images.txt; then
  echo "✅ File format includes pod name, namespace, and images"
else
  echo "❌ File should include pod name, namespace, and images information"
  exit 1
fi

echo "✅ all-container-images.txt contains multi-container pod details"
exit 0 