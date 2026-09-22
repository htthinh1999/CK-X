#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod copy-pod -n bark >/dev/null 2>&1; then
  echo "Success: pod copy-pod exists in bark"; exit 0
else
  echo "Error: pod copy-pod not found in bark"; exit 1
fi
