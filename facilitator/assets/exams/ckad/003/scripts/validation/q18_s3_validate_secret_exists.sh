#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get secret db-credentials -n magma >/dev/null 2>&1; then
  echo "Success: secret exists"
  exit 0
else
  echo "Error: secret db-credentials not found in magma"
  exit 1
fi
