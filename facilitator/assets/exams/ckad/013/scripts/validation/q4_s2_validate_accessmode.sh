#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
am=$(kubectl get pvc app-data-pvc -n aurora -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
if [ "$am" = "ReadWriteOnce" ]; then
  echo "Success: access mode ReadWriteOnce"
  exit 0
else
  echo "Error: access mode is '$am'"
  exit 1
fi
