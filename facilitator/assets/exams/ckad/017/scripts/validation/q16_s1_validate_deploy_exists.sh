#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deploy critical-app -n lagoon >/dev/null 2>&1; then
  echo "Success: deployment critical-app exists in lagoon"; exit 0
fi
echo "Error: deployment critical-app not found in lagoon"; exit 1
