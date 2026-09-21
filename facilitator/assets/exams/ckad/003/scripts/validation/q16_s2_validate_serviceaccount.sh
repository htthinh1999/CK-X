#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
sa=$(kubectl get pod token-pod -n magma -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)
if [ "$sa" = "fire-sa" ]; then
  echo "Success: uses fire-sa"
  exit 0
else
  echo "Error: serviceAccountName is '$sa', expected fire-sa"
  exit 1
fi
