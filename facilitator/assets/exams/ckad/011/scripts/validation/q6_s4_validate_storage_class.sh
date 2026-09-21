#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
sc=$(kubectl get pvc sea-pvc -n depths -o jsonpath='{.spec.storageClassName}' 2>/dev/null)
if [ "$sc" = "manual" ]; then
  echo "Success: storage class is manual"
  exit 0
else
  echo "Error: storage class is '$sc', expected manual"
  exit 1
fi
