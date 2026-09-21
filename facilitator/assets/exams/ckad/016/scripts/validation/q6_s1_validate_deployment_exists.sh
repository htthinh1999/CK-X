#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get deployment api-gateway -n voltage >/dev/null 2>&1; then
  echo "Success: deployment api-gateway exists"; exit 0
fi
echo "Error: deployment api-gateway not found in voltage"; exit 1
