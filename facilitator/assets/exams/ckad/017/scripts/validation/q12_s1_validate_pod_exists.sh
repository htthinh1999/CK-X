#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod batch-worker -n abyss >/dev/null 2>&1; then
  echo "Success: pod batch-worker exists in abyss"; exit 0
fi
echo "Error: pod batch-worker not found in abyss"; exit 1
