#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment compute-app -n tower -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)
if [ "$val" = "128Mi" ]; then
  echo "Success: Requests memory ($val)"
  exit 0
else
  echo "Error: Requests memory - got '$val', expected '128Mi'"
  exit 1
fi
