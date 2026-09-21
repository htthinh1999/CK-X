#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service web-svc -n flame >/dev/null 2>&1; then
  echo "Success: service exists"
  exit 0
else
  echo "Error: service web-svc not found in flame"
  exit 1
fi
