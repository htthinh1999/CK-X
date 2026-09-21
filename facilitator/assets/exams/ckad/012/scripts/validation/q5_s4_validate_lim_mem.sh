#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment compute-app -n tower -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}' 2>/dev/null)
if [ "$val" = "256Mi" ]; then
  echo "Success: Limits memory ($val)"
  exit 0
else
  echo "Error: Limits memory - got '$val', expected '256Mi'"
  exit 1
fi
