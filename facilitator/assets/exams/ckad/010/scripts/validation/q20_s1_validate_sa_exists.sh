#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get serviceaccount token-sa -n blessing >/dev/null 2>&1; then
  echo "Success: ServiceAccount token-sa exists in blessing"
  exit 0
else
  echo "Error: ServiceAccount token-sa not found in blessing"
  exit 1
fi
