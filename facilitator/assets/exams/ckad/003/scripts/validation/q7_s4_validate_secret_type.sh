#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
t=$(kubectl get secret db-credentials -n magma -o jsonpath='{.type}' 2>/dev/null)
if [ "$t" = "Opaque" ]; then
  echo "Success: type Opaque"
  exit 0
else
  echo "Error: type is '$t', expected Opaque"
  exit 1
fi
