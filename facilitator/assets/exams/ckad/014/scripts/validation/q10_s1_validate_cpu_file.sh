#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/10/cpu-usage.txt
if [ -f "$F" ]; then
  content=$(cat "$F")
  if [ -n "$content" ]; then
    echo "Success: cpu-usage.txt exists and is non-empty (content: $content)"
    exit 0
  fi
fi
echo "Error: cpu-usage.txt missing or empty"
exit 1
