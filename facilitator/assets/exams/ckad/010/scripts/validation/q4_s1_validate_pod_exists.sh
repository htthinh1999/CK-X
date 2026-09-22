#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod ready-pod -n field >/dev/null 2>&1; then
  echo "Success: Pod ready-pod exists in field"
  exit 0
else
  echo "Error: Pod ready-pod not found in field"
  exit 1
fi
