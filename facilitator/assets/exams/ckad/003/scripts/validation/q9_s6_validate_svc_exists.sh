#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service frontend-svc -n blaze >/dev/null 2>&1; then
  echo "Success: frontend-svc exists"
  exit 0
else
  echo "Error: service frontend-svc not found in blaze"
  exit 1
fi
