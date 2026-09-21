#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service backend -n rice >/dev/null 2>&1; then
  echo "Success: Service backend exists in rice"
  exit 0
else
  echo "Error: Service backend not found in rice"
  exit 1
fi
