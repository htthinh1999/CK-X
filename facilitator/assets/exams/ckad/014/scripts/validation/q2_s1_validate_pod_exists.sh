#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod data-processor -n crescent >/dev/null 2>&1; then
  echo "Success: pod data-processor exists in crescent"
  exit 0
else
  echo "Error: pod data-processor not found in crescent"
  exit 1
fi
