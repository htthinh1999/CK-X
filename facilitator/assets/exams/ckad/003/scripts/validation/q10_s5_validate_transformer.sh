#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
n=$(kubectl get pod data-transform -n phoenix -o jsonpath='{.spec.containers[?(@.name=="transformer")].name}' 2>/dev/null)
if [ "$n" = "transformer" ]; then
  echo "Success: transformer container exists"
  exit 0
else
  echo "Error: transformer container not found"
  exit 1
fi
