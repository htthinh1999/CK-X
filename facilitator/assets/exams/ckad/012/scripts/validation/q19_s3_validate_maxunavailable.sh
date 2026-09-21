#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment rolling-app -n parapet -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
if [ "$val" = "0" ]; then
  echo "Success: maxUnavailable ($val)"
  exit 0
else
  echo "Error: maxUnavailable - got '$val', expected '0'"
  exit 1
fi
