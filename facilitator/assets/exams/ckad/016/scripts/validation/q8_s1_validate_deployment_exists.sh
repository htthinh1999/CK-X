#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment api-worker -n charge >/dev/null 2>&1; then
  echo "Success: deployment api-worker exists in charge"; exit 0
fi
echo "Error: deployment api-worker not found in charge"; exit 1
