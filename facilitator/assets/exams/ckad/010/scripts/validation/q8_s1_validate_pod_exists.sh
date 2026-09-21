#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod quota-pod -n fortune >/dev/null 2>&1; then
  echo "Success: Pod quota-pod exists in fortune"
  exit 0
else
  echo "Error: Pod quota-pod not found in fortune"
  exit 1
fi
