#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service app-svc -n grain >/dev/null 2>&1; then
  echo "Success: Service app-svc exists in grain"
  exit 0
else
  echo "Error: Service app-svc not found in grain"
  exit 1
fi
