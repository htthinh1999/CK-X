#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pvc glory-pvc -n glory >/dev/null 2>&1; then
  echo "Success: pvc glory-pvc exists in glory"
  exit 0
fi
echo "Error: pvc glory-pvc not found in glory"
exit 1
