#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get service backend-svc -n parapet >/dev/null 2>&1; then
  echo "Success: Service backend-svc exists in parapet"
  exit 0
else
  echo "Error: Service backend-svc exists in parapet - not found"
  exit 1
fi
