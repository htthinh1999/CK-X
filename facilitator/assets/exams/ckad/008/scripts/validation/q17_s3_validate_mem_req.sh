#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

v=$(kubectl get pod resource-pod -n cave -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
if [ "$v" = "256Mi" ]; then
  echo "Success: memory request is 256Mi"; exit 0
else
  echo "Error: memory request is '$v', expected 256Mi"; exit 1
fi
