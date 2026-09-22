#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get netpol secure-policy -n abyss >/dev/null 2>&1; then
  echo "Success: networkpolicy secure-policy exists in abyss"; exit 0
fi
echo "Error: networkpolicy secure-policy not found in abyss"; exit 1
