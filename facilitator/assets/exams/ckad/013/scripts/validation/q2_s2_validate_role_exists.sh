#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get role deploy-role -n zenith >/dev/null 2>&1; then
  echo "Success: Role deploy-role exists"
  exit 0
else
  echo "Error: Role deploy-role not found"
  exit 1
fi
