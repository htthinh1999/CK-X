#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod init-chain -n guardian >/dev/null 2>&1; then
  echo "Success: pod init-chain exists in guardian"
  exit 0
fi
echo "Error: pod init-chain missing in guardian"
exit 1
