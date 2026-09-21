#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod projected-pod -n melody >/dev/null 2>&1; then
  echo "Success: pod projected-pod exists"; exit 0
fi
echo "Error: pod projected-pod not found in melody"; exit 1
