#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get secret db-credentials -n storm >/dev/null 2>&1; then
  echo "Success: secret db-credentials exists"; exit 0
fi
echo "Error: secret db-credentials not found in storm"; exit 1
