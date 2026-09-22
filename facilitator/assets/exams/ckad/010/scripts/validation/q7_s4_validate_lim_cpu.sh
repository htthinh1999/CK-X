#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get quota compute-quota -n fortune -o jsonpath='{.spec.hard.limits\.cpu}' 2>/dev/null)
if [ "$val" = "2" ]; then
  echo "Success: limits.cpu is 2"
  exit 0
else
  echo "Error: limits.cpu incorrect (got '$val')"
  exit 1
fi
