#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pvc sea-pvc -n depths >/dev/null 2>&1; then
  echo "Success: PVC sea-pvc exists in depths"
  exit 0
else
  echo "Error: PVC sea-pvc not found in depths"
  exit 1
fi
