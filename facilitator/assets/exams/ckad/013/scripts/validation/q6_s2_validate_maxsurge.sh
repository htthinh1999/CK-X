#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
m=$(kubectl get deploy api-app -n dawn -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
if [ "$m" = "1" ]; then
  echo "Success: maxSurge is 1"
  exit 0
else
  echo "Error: maxSurge is '$m' (expected 1)"
  exit 1
fi
