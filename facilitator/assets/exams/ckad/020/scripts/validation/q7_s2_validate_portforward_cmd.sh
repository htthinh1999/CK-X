#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
script_path="/tmp/exam/course/7/check.sh"
if [ ! -f "$script_path" ]; then
  echo "Error: $script_path not found"
  exit 1
fi
if grep -q "kubectl port-forward.*svc/backend-api.*9999:8080" "$script_path"; then
  echo "Success: script contains the port-forward command"
  exit 0
fi
echo "Error: script missing kubectl port-forward svc/backend-api 9999:8080"
exit 1
