#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment app-v2 -n grain >/dev/null 2>&1; then
  echo "Success: Deployment app-v2 exists in grain"
  exit 0
else
  echo "Error: Deployment app-v2 not found in grain"
  exit 1
fi
