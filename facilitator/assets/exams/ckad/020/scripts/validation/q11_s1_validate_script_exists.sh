#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
script_path="/tmp/exam/course/11/check.sh"
if [ -f "$script_path" ]; then
  echo "Success: $script_path exists"
  exit 0
fi
echo "Error: $script_path not found"
exit 1
