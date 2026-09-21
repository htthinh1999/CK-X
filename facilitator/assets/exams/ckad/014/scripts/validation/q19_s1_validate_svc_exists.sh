#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service db-ext-svc -n nebula >/dev/null 2>&1; then
  echo "Success: service db-ext-svc exists in nebula"
  exit 0
else
  echo "Error: service db-ext-svc not found in nebula"
  exit 1
fi
