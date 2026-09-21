#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service backend-svc -n gate >/dev/null 2>&1; then
  echo "Success: Service backend-svc exists in gate"
  exit 0
else
  echo "Error: Service backend-svc exists in gate - not found"
  exit 1
fi
