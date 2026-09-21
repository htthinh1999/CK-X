#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod data-pod -n aurora >/dev/null 2>&1; then
  echo "Success: pod data-pod exists"
  exit 0
else
  echo "Error: pod data-pod not found"
  exit 1
fi
