#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service prod-web-svc -n zenith >/dev/null 2>&1; then
  echo "Success: service prod-web-svc exists"
  exit 0
else
  echo "Error: service prod-web-svc not found"
  exit 1
fi
