#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get job batch-processor -n bulwark -o jsonpath='{.spec.completions}' 2>/dev/null)
if [ "$val" = "6" ]; then
  echo "Success: Completions ($val)"
  exit 0
else
  echo "Error: Completions - got '$val', expected '6'"
  exit 1
fi
