#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod logger-app -n stronghold -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$val" = "Running" ]; then
  echo "Success: Pod phase ($val)"
  exit 0
else
  echo "Error: Pod phase - got '$val', expected 'Running'"
  exit 1
fi
