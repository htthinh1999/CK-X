#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod api-pod -n moss >/dev/null 2>&1; then
  echo "Success: pod api-pod exists in moss"; exit 0
else
  echo "Error: pod api-pod not found in moss"; exit 1
fi
