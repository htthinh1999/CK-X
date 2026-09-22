#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
t=$(kubectl get deploy api-app -n dawn -o jsonpath='{.spec.strategy.type}' 2>/dev/null)
if [ "$t" = "RollingUpdate" ]; then
  echo "Success: strategy type RollingUpdate"
  exit 0
else
  echo "Error: strategy type is '$t'"
  exit 1
fi
