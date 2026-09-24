#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get deployment backend -n rice -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$val" = "3" ]; then
  echo "Success: deployment backend has 3 replicas"
  exit 0
else
  echo "Error: deployment backend replicas incorrect (got '$val')"
  exit 1
fi
