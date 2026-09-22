#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment secure-app -n fortress >/dev/null 2>&1; then
  echo "Success: Deployment secure-app exists in fortress"
  exit 0
else
  echo "Error: Deployment secure-app exists in fortress - not found"
  exit 1
fi
