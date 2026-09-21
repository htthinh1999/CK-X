#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get service local-app-svc -n aria >/dev/null 2>&1; then
  echo "Success: service local-app-svc exists"; exit 0
fi
echo "Error: service local-app-svc not found in aria"; exit 1
