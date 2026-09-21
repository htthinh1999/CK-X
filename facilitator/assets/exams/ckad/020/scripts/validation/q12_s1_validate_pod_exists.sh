#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod projected-pod -n origin >/dev/null 2>&1; then
  echo "Success: pod projected-pod exists in origin"
  exit 0
fi
echo "Error: pod projected-pod not found in origin"
exit 1
