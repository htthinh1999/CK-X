#!/bin/bash

# Check if the release notes file exists
if [[ ! -f "/tmp/release-notes.txt" ]]; then
  echo "❌ File '/tmp/release-notes.txt' not found"
  exit 1
fi

# Check if the file has content
if [[ ! -s "/tmp/release-notes.txt" ]]; then
  echo "❌ Release notes file is empty"
  exit 1
fi

# Check if the file actually contains release notes
if ! grep -q "RELEASE NOTES" /tmp/release-notes.txt && ! grep -q "Bitnami" /tmp/release-notes.txt && ! grep -q "nginx" /tmp/release-notes.txt; then
  echo "❌ File does not appear to contain Helm release notes"
  exit 1
fi

echo "✅ Release notes are saved correctly to /tmp/release-notes.txt"
exit 0 