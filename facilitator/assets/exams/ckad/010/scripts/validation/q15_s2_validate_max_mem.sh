#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get limitrange pod-limits -n blessing -o jsonpath='{.spec.limits[0].max.memory}' 2>/dev/null)
if [ "$val" = "500Mi" ]; then
  echo "Success: max memory is 500Mi"
  exit 0
else
  echo "Error: max memory incorrect (got '$val')"
  exit 1
fi
