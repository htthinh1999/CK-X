#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get secret registry-creds -n radiance >/dev/null 2>&1; then
  echo "Success: secret registry-creds exists"
  exit 0
else
  echo "Error: secret registry-creds not found"
  exit 1
fi
