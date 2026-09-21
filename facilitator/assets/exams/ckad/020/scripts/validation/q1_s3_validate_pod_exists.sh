#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod genesis-pod -n genesis >/dev/null 2>&1; then
  echo "Success: pod genesis-pod exists in genesis"
  exit 0
fi
echo "Error: pod genesis-pod not found in genesis"
exit 1
