#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment app-v1 -n grain >/dev/null 2>&1; then
  echo "Success: Deployment app-v1 exists in grain"
  exit 0
else
  echo "Error: Deployment app-v1 not found in grain"
  exit 1
fi
