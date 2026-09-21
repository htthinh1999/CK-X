#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod data-pod -n rice >/dev/null 2>&1; then
  echo "Success: Pod data-pod exists in rice"
  exit 0
else
  echo "Error: Pod data-pod not found in rice"
  exit 1
fi
