#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get networkpolicy deny-external -n dusk >/dev/null 2>&1; then
  echo "Success: networkpolicy deny-external exists in dusk"
  exit 0
else
  echo "Error: networkpolicy deny-external not found in dusk"
  exit 1
fi
