#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
m=$(kubectl get deploy api-app -n dawn -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
if [ "$m" = "0" ]; then
  echo "Success: maxUnavailable is 0"
  exit 0
else
  echo "Error: maxUnavailable is '$m' (expected 0)"
  exit 1
fi
