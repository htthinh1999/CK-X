#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get quota compute-quota -n fortune -o jsonpath='{.spec.hard.limits\.memory}' 2>/dev/null)
if [ "$val" = "2Gi" ]; then
  echo "Success: limits.memory is 2Gi"
  exit 0
else
  echo "Error: limits.memory incorrect (got '$val')"
  exit 1
fi
