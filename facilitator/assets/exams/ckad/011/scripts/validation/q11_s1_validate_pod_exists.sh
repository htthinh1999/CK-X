#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod sidecar-pod -n abyss >/dev/null 2>&1; then
  echo "Success: Pod sidecar-pod exists in abyss"
  exit 0
else
  echo "Error: Pod sidecar-pod not found in abyss"
  exit 1
fi
