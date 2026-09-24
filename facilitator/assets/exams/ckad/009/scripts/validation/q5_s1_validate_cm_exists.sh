#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get configmap env-config -n meadow >/dev/null 2>&1; then
  echo "Success: configmap env-config exists in meadow"; exit 0
else
  echo "Error: configmap env-config not found in meadow"; exit 1
fi
