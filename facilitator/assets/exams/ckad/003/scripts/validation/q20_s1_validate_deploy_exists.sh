#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment spread-deploy -n blaze >/dev/null 2>&1; then
  echo "Success: deployment exists"
  exit 0
else
  echo "Error: deployment spread-deploy not found in blaze"
  exit 1
fi
