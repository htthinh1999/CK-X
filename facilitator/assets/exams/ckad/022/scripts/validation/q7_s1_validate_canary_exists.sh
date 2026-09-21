#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment legacy-canary -n legacy >/dev/null 2>&1; then
  echo "Success: deployment legacy-canary exists in legacy"
  exit 0
fi
echo "Error: deployment legacy-canary not found in legacy"
exit 1
