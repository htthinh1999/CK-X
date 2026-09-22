#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get pod resource-pod -n cave -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
if [ "$v" = "200m" ]; then
  echo "Success: CPU limit is 200m"; exit 0
else
  echo "Error: CPU limit is '$v', expected 200m"; exit 1
fi
