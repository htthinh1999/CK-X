#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/17/top-pods.txt"
if [ -s "$f" ] && { grep -q "CPU" "$f" 2>/dev/null || grep -q "MEMORY" "$f" 2>/dev/null || grep -q "NAME" "$f" 2>/dev/null; }; then
  echo "Success: pods file contains pod metrics"
  exit 0
else
  echo "Error: pods file does not contain expected metrics format"
  exit 1
fi
