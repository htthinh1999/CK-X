#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment fire-app -n blaze >/dev/null 2>&1; then
  echo "Success: deployment fire-app exists in blaze"
  exit 0
else
  echo "Error: deployment fire-app not found in blaze"
  exit 1
fi
