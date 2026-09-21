#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment rolling-app -n parapet -o jsonpath='{.spec.strategy.type}' 2>/dev/null)
if [ "$val" = "RollingUpdate" ]; then
  echo "Success: Strategy type ($val)"
  exit 0
else
  echo "Error: Strategy type - got '$val', expected 'RollingUpdate'"
  exit 1
fi
