#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service backend-headless -n corona >/dev/null 2>&1; then
  echo "Success: service exists"
  exit 0
else
  echo "Error: service backend-headless not found in corona"
  exit 1
fi
