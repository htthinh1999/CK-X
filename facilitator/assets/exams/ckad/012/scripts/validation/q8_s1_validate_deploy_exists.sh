#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment canary-app -n bulwark >/dev/null 2>&1; then
  echo "Success: Deployment canary-app exists in bulwark"
  exit 0
else
  echo "Error: Deployment canary-app exists in bulwark - not found"
  exit 1
fi
