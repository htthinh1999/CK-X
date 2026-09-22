#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod vol-pod -n cliff >/dev/null 2>&1; then
  echo "Success: pod vol-pod exists"; exit 0
else
  echo "Error: pod vol-pod not found"; exit 1
fi
