#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment compute-app -n tower -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
if [ "$val" = "100m" ]; then
  echo "Success: Requests CPU ($val)"
  exit 0
else
  echo "Error: Requests CPU - got '$val', expected '100m'"
  exit 1
fi
