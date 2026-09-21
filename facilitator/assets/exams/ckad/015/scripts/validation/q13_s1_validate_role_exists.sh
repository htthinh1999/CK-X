#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get role breeze-manager -n breeze >/dev/null 2>&1; then
  echo "Success: Role breeze-manager exists in breeze"
  exit 0
else
  echo "Error: Role breeze-manager not found in breeze"
  exit 1
fi
