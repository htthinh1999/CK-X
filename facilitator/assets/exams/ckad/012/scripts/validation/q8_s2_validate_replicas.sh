#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get deployment canary-app -n bulwark -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$val" = "1" ]; then
  echo "Success: Replicas ($val)"
  exit 0
else
  echo "Error: Replicas - got '$val', expected '1'"
  exit 1
fi
