#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod direct-pod -n coral >/dev/null 2>&1; then
  echo "Success: Pod direct-pod exists in coral"
  exit 0
else
  echo "Error: Pod direct-pod not found in coral"
  exit 1
fi
