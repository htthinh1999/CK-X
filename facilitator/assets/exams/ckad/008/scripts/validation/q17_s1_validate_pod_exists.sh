#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod resource-pod -n cave >/dev/null 2>&1; then
  echo "Success: pod resource-pod exists"; exit 0
else
  echo "Error: pod resource-pod not found"; exit 1
fi
