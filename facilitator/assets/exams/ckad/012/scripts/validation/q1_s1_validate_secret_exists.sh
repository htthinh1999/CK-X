#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get secret db-credentials -n fortress >/dev/null 2>&1; then
  echo "Success: Secret db-credentials exists in fortress"
  exit 0
else
  echo "Error: Secret db-credentials exists in fortress - not found"
  exit 1
fi
