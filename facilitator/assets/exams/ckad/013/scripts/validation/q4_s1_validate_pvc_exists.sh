#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get persistentvolumeclaim app-data-pvc -n aurora >/dev/null 2>&1; then
  echo "Success: PVC app-data-pvc exists"
  exit 0
else
  echo "Error: PVC app-data-pvc not found"
  exit 1
fi
