#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
file_path="/tmp/exam/course/10/events.txt"
if [ ! -f "$file_path" ]; then
  echo "Error: $file_path not found"
  exit 1
fi
header=$(head -n 1 "$file_path")
if echo "$header" | grep -q "TYPE.*REASON.*MESSAGE"; then
  echo "Success: file has correct TYPE/REASON/MESSAGE headers"
  exit 0
fi
echo "Error: file headers incorrect (got '$header')"
exit 1
