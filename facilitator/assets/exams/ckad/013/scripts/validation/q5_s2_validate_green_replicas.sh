#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deploy app-green -n flare -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "3" ]; then
  echo "Success: green replicas is 3"
  exit 0
else
  echo "Error: green replicas is '$r' (expected 3)"
  exit 1
fi
