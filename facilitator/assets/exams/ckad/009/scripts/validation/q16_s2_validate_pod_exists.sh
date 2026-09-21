#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod env-pod -n meadow >/dev/null 2>&1; then
  echo "Success: pod env-pod exists in meadow"; exit 0
else
  echo "Error: pod env-pod not found in meadow"; exit 1
fi
