#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/8/events.txt"
if [ -s "$f" ] && { grep -q "Events:" "$f" 2>/dev/null || grep -q "Type" "$f" 2>/dev/null || grep -q "Normal" "$f" 2>/dev/null || grep -q "Warning" "$f" 2>/dev/null; }; then
  echo "Success: events file contains event information"
  exit 0
else
  echo "Error: events file does not contain expected event format"
  exit 1
fi
