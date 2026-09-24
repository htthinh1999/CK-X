#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/11/cpu-usage.txt"
if [ -f "$f" ]; then
  content=$(cat "$f")
  if [[ "$content" == *"backend-pod-"* ]]; then
    echo "Success: file contains pod name"
    exit 0
  fi
  echo "Error: incorrect pod name ($content)"
  exit 1
fi
echo "Error: $f missing"
exit 1
