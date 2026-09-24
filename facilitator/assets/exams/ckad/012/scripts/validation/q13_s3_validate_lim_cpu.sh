#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment compute-app -n tower -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
if [ "$val" = "200m" ]; then
  echo "Success: Limits CPU ($val)"
  exit 0
else
  echo "Error: Limits CPU - got '$val', expected '200m'"
  exit 1
fi
