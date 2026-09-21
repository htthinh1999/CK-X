#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
name=$(kubectl get pod sidecar-pod -n abyss -o jsonpath='{.spec.containers[?(@.name=="app")].name}' 2>/dev/null)
if [ "$name" = "app" ]; then
  echo "Success: container app exists"
  exit 0
else
  echo "Error: container app not found"
  exit 1
fi
