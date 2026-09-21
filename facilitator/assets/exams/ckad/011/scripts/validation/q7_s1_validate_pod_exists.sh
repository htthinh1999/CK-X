#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod pvc-pod -n depths >/dev/null 2>&1; then
  echo "Success: Pod pvc-pod exists in depths"
  exit 0
else
  echo "Error: Pod pvc-pod not found in depths"
  exit 1
fi
