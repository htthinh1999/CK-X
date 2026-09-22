#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deploy app-blue -n flare -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$r" = "0" ]; then
  echo "Success: blue scaled to 0"
  exit 0
else
  echo "Error: blue replicas is '$r' (expected 0)"
  exit 1
fi
