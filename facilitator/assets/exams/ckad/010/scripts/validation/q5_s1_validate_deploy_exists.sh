#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get deployment backend -n rice >/dev/null 2>&1; then
  echo "Success: Deployment backend exists in rice"
  exit 0
else
  echo "Error: Deployment backend not found in rice"
  exit 1
fi
