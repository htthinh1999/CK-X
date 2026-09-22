#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment canary-v2 -n blaze >/dev/null 2>&1; then
  echo "Success: canary-v2 exists"
  exit 0
else
  echo "Error: deployment canary-v2 not found in blaze"
  exit 1
fi
