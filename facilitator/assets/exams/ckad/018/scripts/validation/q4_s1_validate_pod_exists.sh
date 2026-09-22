#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod shared-process-pod -n cadence >/dev/null 2>&1; then
  echo "Success: pod shared-process-pod exists"; exit 0
fi
echo "Error: pod shared-process-pod not found in cadence"; exit 1
