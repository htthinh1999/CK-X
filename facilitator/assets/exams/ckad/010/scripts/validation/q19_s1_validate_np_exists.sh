#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy db-policy -n shrine >/dev/null 2>&1; then
  echo "Success: NetworkPolicy db-policy exists in shrine"
  exit 0
else
  echo "Error: NetworkPolicy db-policy not found in shrine"
  exit 1
fi
