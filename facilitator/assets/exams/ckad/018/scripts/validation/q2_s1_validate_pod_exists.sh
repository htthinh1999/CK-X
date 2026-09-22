#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod ambassador-pod -n melody >/dev/null 2>&1; then
  echo "Success: pod ambassador-pod exists"; exit 0
fi
echo "Error: pod ambassador-pod not found in melody"; exit 1
