#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get serviceaccount deploy-sa -n zenith >/dev/null 2>&1; then
  echo "Success: ServiceAccount deploy-sa exists"
  exit 0
else
  echo "Error: ServiceAccount deploy-sa not found"
  exit 1
fi
