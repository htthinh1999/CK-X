#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get job batch-processor -n bulwark -o jsonpath='{.spec.parallelism}' 2>/dev/null)
if [ "$val" = "2" ]; then
  echo "Success: Parallelism ($val)"
  exit 0
else
  echo "Error: Parallelism - got '$val', expected '2'"
  exit 1
fi
