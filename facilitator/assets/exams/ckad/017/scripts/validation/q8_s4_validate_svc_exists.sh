#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get svc app-svc -n trench >/dev/null 2>&1; then
  echo "Success: service app-svc exists in trench"; exit 0
fi
echo "Error: service app-svc not found in trench"; exit 1
