#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
strategy=$(kubectl get deployment fire-app -n blaze -o jsonpath='{.spec.strategy.type}' 2>/dev/null)
if [ "$strategy" = "Recreate" ]; then
  echo "Success: strategy is Recreate"
  exit 0
else
  echo "Error: strategy is '$strategy', expected Recreate"
  exit 1
fi
