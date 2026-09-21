#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
name=$(kubectl get pod sidecar-pod -n abyss -o jsonpath='{.spec.containers[?(@.name=="sidecar")].name}' 2>/dev/null)
if [ "$name" = "sidecar" ]; then
  echo "Success: container sidecar exists"
  exit 0
else
  echo "Error: container sidecar not found"
  exit 1
fi
