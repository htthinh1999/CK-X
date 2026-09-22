#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
s=$(kubectl get pod stuck-pod -n solar -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$s" = "Running" ]; then
  echo "Success: pod stuck-pod is Running"
  exit 0
else
  echo "Error: pod stuck-pod status is '$s'"
  exit 1
fi
