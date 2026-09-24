#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/19/nodes.txt"
if [ -s "$f" ] && { grep -q "CPU" "$f" 2>/dev/null || grep -q "MEMORY" "$f" 2>/dev/null || grep -q "%" "$f" 2>/dev/null; }; then
  echo "Success: nodes file contains node metrics"
  exit 0
else
  echo "Error: nodes file does not contain expected metrics format"
  exit 1
fi
