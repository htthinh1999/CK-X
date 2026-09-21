#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod token-pod -n magma >/dev/null 2>&1; then
  echo "Success: pod exists"
  exit 0
else
  echo "Error: pod token-pod not found in magma"
  exit 1
fi
