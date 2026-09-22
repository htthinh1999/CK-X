#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod config-app -n gate >/dev/null 2>&1; then
  echo "Success: Pod config-app exists in gate"
  exit 0
else
  echo "Error: Pod config-app exists in gate - not found"
  exit 1
fi
