#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod live-pod -n shrine >/dev/null 2>&1; then
  echo "Success: Pod live-pod exists in shrine"
  exit 0
else
  echo "Error: Pod live-pod not found in shrine"
  exit 1
fi
