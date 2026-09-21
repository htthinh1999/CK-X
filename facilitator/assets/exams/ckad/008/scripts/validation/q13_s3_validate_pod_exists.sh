#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pod config-pod -n summit >/dev/null 2>&1; then
  echo "Success: pod config-pod exists"; exit 0
else
  echo "Error: pod config-pod not found"; exit 1
fi
