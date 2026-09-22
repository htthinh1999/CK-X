#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
mode=$(kubectl get pvc sea-pvc -n depths -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
if [ "$mode" = "ReadWriteOnce" ]; then
  echo "Success: access mode is ReadWriteOnce"
  exit 0
else
  echo "Error: access mode is '$mode', expected ReadWriteOnce"
  exit 1
fi
