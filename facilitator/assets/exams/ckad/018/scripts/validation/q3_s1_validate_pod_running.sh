#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get pod metrics-pod -n tempo >/dev/null 2>&1; then
  echo "Error: pod metrics-pod not found in tempo"; exit 1
fi
status=$(kubectl get pod metrics-pod -n tempo -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$status" == "Running" ]; then
  echo "Success: metrics-pod is Running"; exit 0
fi
echo "Error: metrics-pod phase is '$status', expected Running"; exit 1
