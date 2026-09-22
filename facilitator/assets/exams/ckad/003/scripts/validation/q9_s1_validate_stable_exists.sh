#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment stable-v1 -n blaze >/dev/null 2>&1; then
  echo "Success: stable-v1 exists"
  exit 0
else
  echo "Error: deployment stable-v1 not found in blaze"
  exit 1
fi
