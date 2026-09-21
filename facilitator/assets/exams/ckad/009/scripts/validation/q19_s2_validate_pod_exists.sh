#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod sa-pod -n root >/dev/null 2>&1; then
  echo "Success: pod sa-pod exists in root"; exit 0
else
  echo "Error: pod sa-pod not found in root"; exit 1
fi
