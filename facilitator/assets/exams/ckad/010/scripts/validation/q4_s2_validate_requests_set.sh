#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod quota-pod -n fortune -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
if [ -n "$val" ]; then
  echo "Success: resource requests set"
  exit 0
else
  echo "Error: resource requests missing"
  exit 1
fi
