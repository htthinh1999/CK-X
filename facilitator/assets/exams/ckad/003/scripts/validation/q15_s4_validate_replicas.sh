#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deployment -n flare -l app.kubernetes.io/instance=phoenix-api -o jsonpath='{.items[0].spec.replicas}' 2>/dev/null)
if [ "$r" = "3" ]; then
  echo "Success: 3 replicas"
  exit 0
else
  echo "Error: replicas is '$r', expected 3"
  exit 1
fi
