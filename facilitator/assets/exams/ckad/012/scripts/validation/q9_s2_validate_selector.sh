#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get service backend-svc -n parapet -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$val" = "backend-api" ]; then
  echo "Success: Selector app ($val)"
  exit 0
else
  echo "Error: Selector app - got '$val', expected 'backend-api'"
  exit 1
fi
