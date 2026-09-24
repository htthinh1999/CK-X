#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
file_path="/tmp/exam/course/5/events.txt"
if [ -f "$file_path" ]; then
  echo "Success: $file_path exists"
  exit 0
fi
echo "Error: $file_path not found"
exit 1
