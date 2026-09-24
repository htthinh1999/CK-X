#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod combined-app -n crescent >/dev/null 2>&1; then
  echo "Success: pod combined-app exists in crescent"
  exit 0
else
  echo "Error: pod combined-app not found in crescent"
  exit 1
fi
