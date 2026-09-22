#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod exec-pod -n storm >/dev/null 2>&1; then
  echo "Success: Pod exec-pod exists in storm"
  exit 0
else
  echo "Error: Pod exec-pod not found in storm"
  exit 1
fi
