#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment rolling-app -n parapet -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
if [ "$val" = "1" ]; then
  echo "Success: maxSurge ($val)"
  exit 0
else
  echo "Error: maxSurge - got '$val', expected '1'"
  exit 1
fi
