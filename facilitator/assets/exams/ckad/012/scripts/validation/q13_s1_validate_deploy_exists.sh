#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment web-server -n citadel >/dev/null 2>&1; then
  echo "Success: Deployment web-server exists in citadel"
  exit 0
else
  echo "Error: Deployment web-server exists in citadel - not found"
  exit 1
fi
