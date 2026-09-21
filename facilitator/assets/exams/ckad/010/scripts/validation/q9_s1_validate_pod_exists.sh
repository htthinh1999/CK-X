#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod cap-pod -n golden >/dev/null 2>&1; then
  echo "Success: Pod cap-pod exists in golden"
  exit 0
else
  echo "Error: Pod cap-pod not found in golden"
  exit 1
fi
