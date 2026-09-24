#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
script_path="/tmp/exam/course/7/check.sh"
if [ ! -f "$script_path" ]; then
  echo "Error: $script_path not found"
  exit 1
fi
if grep -q "curl.*http://localhost:9999/health" "$script_path"; then
  echo "Success: script contains the curl health command"
  exit 0
fi
echo "Error: script missing curl http://localhost:9999/health"
exit 1
