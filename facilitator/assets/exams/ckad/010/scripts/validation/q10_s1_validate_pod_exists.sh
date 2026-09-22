#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod shared-pod -n bounty >/dev/null 2>&1; then
  echo "Success: Pod shared-pod exists in bounty"
  exit 0
else
  echo "Error: Pod shared-pod not found in bounty"
  exit 1
fi
