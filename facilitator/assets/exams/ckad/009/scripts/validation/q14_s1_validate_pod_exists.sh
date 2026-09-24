#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get pod gpu-pod -n fern >/dev/null 2>&1; then
  echo "Success: pod gpu-pod exists in fern"; exit 0
else
  echo "Error: pod gpu-pod not found in fern"; exit 1
fi
