#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod quota-pod -n fortune -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
if [ -n "$val" ]; then
  echo "Success: resource limits set"
  exit 0
else
  echo "Error: resource limits missing"
  exit 1
fi
