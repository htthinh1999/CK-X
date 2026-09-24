#!/bin/bash

# Check if the output file exists
if [[ ! -f "/tmp/pod-images.txt" ]]; then
  echo "❌ File '/tmp/pod-images.txt' not found"
  exit 1
fi

# Check if the file has content
if [[ ! -s "/tmp/pod-images.txt" ]]; then
  echo "❌ File '/tmp/pod-images.txt' is empty"
  exit 1
fi

# Check if the file contains custom column headers
if ! grep -q "POD.*NAMESPACE.*IMAGE" /tmp/pod-images.txt; then
  echo "❌ File should contain column headers for POD, NAMESPACE, and IMAGE"
  exit 1
fi

# Check if our sample pods are listed
if ! grep -q "nginx-pod.*custom-columns-demo.*nginx:1.19" /tmp/pod-images.txt; then
  echo "❌ File should contain nginx-pod from custom-columns-demo namespace with image nginx:1.19"
  exit 1
fi

if ! grep -q "busybox-pod.*custom-columns-demo.*busybox" /tmp/pod-images.txt; then
  echo "❌ File should contain busybox-pod from custom-columns-demo namespace"
  exit 1
fi

# Check if the file contains pods from other namespaces
# This is a simplistic check - in a real scenario we'd verify actual pods from other namespaces
NAMESPACE_COUNT=$(grep -v "custom-columns-demo" /tmp/pod-images.txt | grep -v "NAMESPACE" | wc -l)
if [[ "$NAMESPACE_COUNT" -eq 0 ]]; then
  echo "❌ File should contain pods from namespaces other than custom-columns-demo"
  exit 1
fi

echo "✅ pod-images.txt file exists with correct custom column format"
exit 0 