#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment frontend-app -n solar >/dev/null 2>&1; then
  echo "Success: deployment frontend-app exists"
  exit 0
else
  echo "Error: deployment frontend-app not found"
  exit 1
fi
