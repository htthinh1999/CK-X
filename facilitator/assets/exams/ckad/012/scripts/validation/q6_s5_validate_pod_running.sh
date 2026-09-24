#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod config-app -n gate -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$val" = "Running" ]; then
  echo "Success: Pod phase ($val)"
  exit 0
else
  echo "Error: Pod phase - got '$val', expected 'Running'"
  exit 1
fi
