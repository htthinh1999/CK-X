#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment quota-app -n garrison >/dev/null 2>&1; then
  echo "Success: Deployment quota-app exists in garrison"
  exit 0
else
  echo "Error: Deployment quota-app exists in garrison - not found"
  exit 1
fi
