#!/bin/bash

# Check if the index.html exists
if [[ ! -f "/tmp/index.html" ]]; then
  echo "❌ File '/tmp/index.html' not found"
  exit 1
fi

# Check if the HTML contains necessary content
if ! grep -q "Hello from CKAD Docker Question" /tmp/index.html; then
  echo "❌ HTML file should contain 'Hello from CKAD Docker Question'"
  exit 1
fi

# Check basic HTML structure
if ! grep -q "<!DOCTYPE html>" /tmp/index.html; then
  echo "❌ HTML file should have DOCTYPE declaration"
  exit 1
fi

if ! grep -q "<html>" /tmp/index.html; then
  echo "❌ HTML file should contain <html> tag"
  exit 1
fi

if ! grep -q "<body>" /tmp/index.html; then
  echo "❌ HTML file should contain <body> tag"
  exit 1
fi

echo "✅ index.html exists with correct content"
exit 0 