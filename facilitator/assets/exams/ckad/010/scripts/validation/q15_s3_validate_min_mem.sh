#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get limitrange pod-limits -n blessing -o jsonpath='{.spec.limits[0].min.memory}' 2>/dev/null)
if [ "$val" = "100Mi" ]; then
  echo "Success: min memory is 100Mi"
  exit 0
else
  echo "Error: min memory incorrect (got '$val')"
  exit 1
fi
