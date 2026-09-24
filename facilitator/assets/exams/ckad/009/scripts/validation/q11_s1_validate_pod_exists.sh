#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod debug-pod -n meadow >/dev/null 2>&1; then
  echo "Success: pod debug-pod exists in meadow"; exit 0
else
  echo "Error: pod debug-pod not found in meadow"; exit 1
fi
