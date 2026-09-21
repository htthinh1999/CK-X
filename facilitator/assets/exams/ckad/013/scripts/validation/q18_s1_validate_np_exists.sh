#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get networkpolicy api-allow -n sunbeam >/dev/null 2>&1; then
  echo "Success: NetworkPolicy api-allow exists"
  exit 0
else
  echo "Error: NetworkPolicy api-allow not found"
  exit 1
fi
